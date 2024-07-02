#!/usr/bin/expect

# 从命令行参数读取参数
set file [lindex $argv 0]
set password [lindex $argv 1]

# 读取文件中的每一行
while {[gets $file line] != -1} {
    # 提取键和值
    set key [lindex [split $line "="] 0]

    # 拼接命令并执行
    set command "cd /avs/omni && ./omni operator register --config-file /avs/eigenlayer-cli/eigenlayer-config/operator/$key/operator.yaml"
    puts "$command"

    # 运行命令并等待提示输入密码的消息
    spawn bash -c $command

    expect "decrypt the ecdsa private key:"
    puts "---输入密码并回车---"
    sleep 5
    send "$password"
    send "\n"

    expect "status=1"
    puts "---注册成功结束交互子进程---"
    sleep 15
    send "\x03"

    interact
}

# 关闭文件
close $file
