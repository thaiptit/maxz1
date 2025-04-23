#!/bin/bash

# Sao lưu tệp cấu hình
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Menu lựa chọn nhà cung cấp VPS
while true; do
    echo "Choose a VPS:"
    echo "1. Google Cloud Platform"
    echo "2. Amazon Web Services"
    echo "0. Exit"
    echo -n "Nhập loại vps( 1 hoặc 2): "
    read choice

    case $choice in
        1|2)
            # Cấu hình chung
            
            sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
            sed -i 's/KbdInteractiveAuthentication no/#KbdInteractiveAuthentication no/g' /etc/ssh/sshd_config

            # Cấu hình riêng cho từng nhà cung cấp
            if [[ $choice -eq 1 ]]; then
                sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
            elif [[ $choice -eq 2 ]]; then
                sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
            fi

            # Đặt lại mật khẩu root
            passwd
            ;;
        0)
            echo "Thoát chương trình."
            exit 0
            ;;
        *)
            echo "Lựa chọn không hợp lệ. Vui lòng chọn 1 hoặc 2."
            ;;
    esac

    # Khởi động lại dịch vụ SSH
    systemctl restart sshd
    echo "Cấu hình SSH đã được cập nhật."
    break
done
