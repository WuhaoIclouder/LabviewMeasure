#!/usr/bin/python

import os
import sys
import startrs
import pxssh
from log import *
from ConfigParser import SafeConfigParser


config_file = "labviewservice.ini"
if len(sys.argv) > 1:
    config_file = sys.argv[1]

# Read config file
config = SafeConfigParser(os.environ)
try:
    l = config.read(config_file)
    if len(l) != 1 or l[0] != config_file:
        print("read() config file[%s] failed!" % config_file)
        exit(1)
except:
    print("read config_file[%s] failed: catch exception type[%s], value[%s]" %
          (config_file, sys.exc_info()[0], sys.exc_info()[1]))
    exit(1)

log_level = "DEBUG"
log_file = "startlabviewservice.log"
try:
    log_level = config.get("common", "log_level")
    log_file = config.get("common", "log_file")
except:
    pass

if not init_log(log_level, log_file):
    print("init_log() failed: log_level[%s], log_level[%s]" %
          (log_level, log_file))
    exit(1)

pexpect_log_file = "startlabviewservice_pexpect.log"
try:
    pexpect_log_file = config.get("common", "pexpect_log_file")
except:
    warn_log("common.pexpect_log_file not found in config file[%s], use[%s]",
             config_file, pexpect_log_file)

try:
    server = config.get("start", "server")
    script = config.get("start", "script")
    wait_time = config.getint("start", "wait_time")
    download_time = config.getint("start", "download_time")

    remote_host = config.get("remote", "host")
    remote_user = config.get("remote", "user")
    remote_password = config.get("remote", "password")
except:
    error_log("Get config from file[%s] failed: exception type[%s], value[%s]",
              config_file, sys.exc_info()[0], sys.exc_info()[1])
    print("Start imgxfer failed: get config from file[%s] failed!" %
          config_file)
    exit(1)


try:
    remote_cwd = config.get("remote", "cwd")
except:
    warn_log("remote.cwd not found in config file[%s]", config_file)
    remote_cwd = None

try:
    f = open(pexpect_log_file, "a+")

    # Try ssh again
    p = pxssh.pxssh()
    p.logfile_read = f
    srs = startrs.StartRemoteServer(p)
    if not srs.login(remote_host, remote_user, remote_password, remote_cwd):
        warn_log("login() by SSH failed: remote host[%s], user[%s], "
                     "password[%s], cwd[%s]", remote_host, remote_user,
                     remote_password, remote_cwd)
        exit(1)
    else:
        debug_log("login() by SSH to remote host[%s] success", remote_host)

    if not srs.start_server(server, script):
        fatal_log("start server[%s] failed: script[%s], "
                  , server, script)
        exit(1)
    else:
        info_log("start server[%s] success!", server)
        print("Start labviewservice successfully!")
except:
    fatal_log("start server[%s] failed: exception type[%s], value[%s]",
              server, sys.exc_info()[0], sys.exc_info()[1])
    print("Start labviewservice failed!")
    exit(1)

try:
    if fuction_select == "set volt":
        if not srs.set_volt(volt):
            result = "set volt error"
except:
    print("test fail")

"""   if fuction_select == "channel ctrl":
     if not srs.channel_ctrl(channel_list):
         result = "channel ctrl error"

 if fuction_select == "set time":
     if not srs.set_time(time):
         result = "set time error"

 if fuction_select == "send phase":
     if not srs.send_phase(phase_list):
         result = "set phase error"

 if fuction_select == "output ctrl":
     if not srs.output_ctrl(switch):
         result = "start output error"

 if fuction_select == "channel read"
     srs.read_channel()
"""
