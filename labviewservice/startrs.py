"""Start a server locate on a remote Linux machine. The remote Linux machine
should be installed bash. First we try to connect the remote Linux host by SSH.
And try telnet again if failed. If we succeed to login, we check if the package
of server is existed. If not, we try scp or sftp or ftp get the package. And
after all, we start the server.
"""

import os
import sys
import pxssh
import time
from pexpect import TIMEOUT
from log import *

__all__ = [
    "StartRemoteServer"
]


class StartRemoteServer(object):
    """
    Start remote server.
    """

    def __init__(self, connector=pxssh.pxssh()):
        """
        The connector is pxssh.pxssh if connect by SSH. If we connect by
        Telnet, we should create a new class inherited from pexpect.spawn, and
        implement login(), logout(), prompt(), set_unique_prompt()
        """
        self.connector = connector

        # pxssh.UNIQUE_PROMPT is "\[PEXPECT\][\$\#] ", set prompt for csh
        # should not contain slash(\)
        if isinstance(self.connector, pxssh.pxssh):
            self.connector.PROMPT_SET_CSH = "set prompt='[PEXPECT]$ '"

        # Echo command result
        self.echo_cmd_result = ""

    def set_tty(self):
        """
        Set window size and close echo.
        """
        try:
            # Increase the width of tty to enable long line grep in check_server()
            self.connector.setwinsize(24, 256)
            # echo default is False
            self.connector.setecho(False)
            return True
        except:
            error_log("set tty failed: exception type[%s], value[%s]",
                      sys.exc_info()[0], sys.exc_info()[1])
            return False

    def check_file(self, filename, timeout=2):
        """
        Check file is exist or not.
        """
        list_file = "ls " + filename + self.echo_cmd_result
        self.connector.sendline(list_file)
        i = self.connector.expect(['\r\n0\r\n', '\r\n1\r\n', '\r\n2\r\n',
                                   TIMEOUT], timeout=timeout)
        if i != 0:
            warn_log("File[%s] not found", filename)
            return False
        return True

    def remove_file(self, filename, timeout=2):
        """
        Remove file
        """
        rm_file = "rm -fr " + filename + self.echo_cmd_result
        self.connector.sendline(rm_file)
        i = self.connector.expect(['\r\n0\r\n', '\r\n1\r\n', '\r\n2\r\n',
                                   TIMEOUT], timeout=timeout)
        if i != 0:
            warn_log("Command[%s] failed", rm_file)
            return False
        return True

    def change_work_directory(self, path):
        """
        Change work directory to path. The path will be created if not existed.
        """
        if not self.check_file(path):
            warn_log("Path[%s] not found, try to create", path)
            create_path = "mkdir -p " + path + self.echo_cmd_result
            self.connector.sendline(create_path)
            i = self.connector.expect(['\r\n0\r\n', '\r\n1\r\n', TIMEOUT],
                                      timeout=2)
            if i != 0:
                error_log("Can't create path[%s]", path)
                return False
            else:
                info_log("Create path[%s] successfully!", path)

        # Now change current work directory
        cd_path = "cd " + path + self.echo_cmd_result
        self.connector.sendline(cd_path)
        i = self.connector.expect(['\r\n0\r\n', '\r\n1\r\n', TIMEOUT],
                                  timeout=2)
        if i != 0:
            error_log("Can't change work directory to path[%s], i[%d]", path, i)
            return False
        else:
            debug_log("Change work directory to path[%s] successfully!", path)
            return True

    def check_command(self, cmd):
        """
        Check the command is existed or not
        """
        which = "which " + cmd + self.echo_cmd_result
        self.connector.sendline(which)
        i = self.connector.expect(['\r\n0\r\n', '\r\n1\r\n', '\r\n2\r\n'])
        if i == 0:
            debug_log("command[%s] found!", cmd)
            return True
        else:
            warn_log("command[%s] not found!", cmd)
            return False


    def start_server(self, server, script):
        """
        Start server by script and check the server
        """
        self.connector.sendline(script)
        expect = "88.Exit"
        i = self.connector.expect([expect, TIMEOUT], timeout=2)
        if i == 0:
            info_log("Start server[%s] success!",server)
            return True
        else:
            warn_log("Start server[%s] failed!",server)
            return False

    def stop_server(self):
        self.connector.sendline("88")
        i = self.connector.expect(["root", TIMEOUT], timeout=2)
        if i == 0:
            info_log("Stop server[%s] success!")
            return True
        else:
            warn_log("Stop server[%s] failed!")
            return False

    def login(self, host, user, password, cwd=None):
        """
        Login remote host by user and password
        """
        try:
            ret = self.connector.login(host, user, password,
                                       original_prompt=r"[#$%]",
                                       auto_prompt_reset=False)
            if not ret:
                error_log("login host[%s], with user[%s], password[%s] failed",
                          host, user, password)
                return False

            if cwd is not None:
                if not self.change_work_directory(cwd):
                    error_log("change_work_directory() to [%s] failed", cwd)
                    return False

            if not self.set_tty():
                error_log("set_tty() failed!")
                return False

            return True
        except:
            error_log("login host[%s], with user[%s], password[%s] failed: "
                      "catch exception type[%s], value[%s]", host, user,
                      password, sys.exc_info()[0], sys.exc_info()[1])
            return False

    def set_volt(self,volt):
        self.connector.sendline("8")
        i = self.connector.expect(["INPUT Voltage", TIMEOUT], timeout=2)
        if i:
            warn_log("send command failed!")
            return False

        self.connector.sendline(str(volt))
        i = self.connector.expect(["Set Voltage", TIMEOUT], timeout=2)
        if i:
            warn_log("send command failed!")
            return False
        return True

    def send_phase(self, phase_list):
        self.connector.sendline("23")
        i = self.connector.expect(["Set phase", TIMEOUT], timeout=2)
        if i:
            warn_log("send command failed!")
            return False
        channel_no = 0
        for elem in phase_list:
            self.connector.sendline("1")
            i = self.connector.expect(["Input channel No:", TIMEOUT], timeout=2)
            if i:
                warn_log("send command failed!")
                return False
            self.connector.sendline(str(channel_no))
            i = self.connector.expect(["Input channel phase:", TIMEOUT], timeout=2)
            if i:
                warn_log("send command failed!")
                return False
            self.connector.sendline(str(elem))
            i = self.connector.expect(["Set phase", TIMEOUT], timeout=2)
            if i:
                warn_log("send command failed!")
                return False
            channel_no = channel_no + 1

        self.connector.sendline("2")
        i = self.connector.expect(["Write to FPGA over", TIMEOUT], timeout=2)
        if i:
            warn_log("send command failed!")
            return False

        self.connector.sendline("88")
        i = self.connector.expect(["CHS", TIMEOUT], timeout=2)
        if i:
            warn_log("send command failed!")
            return False
        return True

    def set_time(self, time):
        self.connector.sendline("14")
        i = self.connector.expect(["Dump", TIMEOUT], timeout=2)
        if i:
            warn_log("send command failed!")
            return False

        self.connector.sendline("1")
        i = self.connector.expect(["Input time", TIMEOUT], timeout=2)
        if i:
            warn_log("send command failed!")
            return False

        self.connector.sendline(str(time))
        i = self.connector.expect(["7.Dump:", TIMEOUT], timeout=2)
        if i:
            warn_log("send command failed!")
            return False

        self.connector.sendline("88")
        i = self.connector.expect(["CHS", TIMEOUT], timeout=2)
        if i:
            warn_log("send command failed!")
            return False
        return True

    def output_ctrl(self, status):
        self.connector.sendline("14")
        i = self.connector.expect(["7.Dump:", TIMEOUT], timeout=2)
        if i:
            warn_log("send command failed!")
            return False

        if status == 1:
            self.connector.sendline("4")
            i = self.connector.expect(["Start heat", TIMEOUT], timeout=2)
            if i:
                warn_log("send command failed!")
                return False
        else:
            self.connector.sendline("5")
            i = self.connector.expect(["Stop heat", TIMEOUT], timeout=2)
            if i:
                warn_log("send command failed!")
                return False
        self.connector.sendline("88")
        i = self.connector.expect(["CHS", TIMEOUT], timeout=2)
        if i:
            warn_log("send command failed!")
            return False
        return True

        self.connector.sendline("88")
        i = self.connector.expect(["CHS", TIMEOUT], timeout=2)
        if i:
            warn_log("send command failed!")
            return False

    def channel_ctrl(self,status_list):
        channel_no = 0
        for elem in status_list:
            self.connector.sendline("22")
            i = self.connector.expect(["Input channel No", TIMEOUT], timeout=2)
            if i:
                warn_log("send command failed!")
                return False
            self.connector.sendline(str(channel_no))
            i = self.connector.expect(["Input channel status", TIMEOUT], timeout=2)
            if i:
                warn_log("send command failed!")
                return False
            self.connector.sendline(str(elem))
            i = self.connector.expect(["CHS", TIMEOUT], timeout=2)
            if i:
                warn_log("send command failed!")
                return False
            channel_no = channel_no + 1
        return True

    def read_channel(self):
        self.connector.sendline("9")
        i = self.connector.expect(["CHS", TIMEOUT], timeout=2)
        if i:
            warn_log("send command failed!")
            return False
        string1 = self.connector.before
        string = self.connector.readline()
        string = self.connector.readline()
        self.connector.sendline("88")
        return True