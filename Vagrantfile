Vagrant.configure("2") do |config|
  
  config.vm.box = "parallels/ubuntu-14.04"

  config.vm.provider "parallels" do |v|
     v.name = "Ubuntu Linux 14.04 - Swift Development"
  end

  config.vm.provision "fix-no-tty", type: "shell" do |s|
     s.privileged = false
     s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end
 
  config.vm.provision "shell", inline: <<-SHELL
  
    export DEBIAN_FRONTEND=noninteractive

    sudo apt-get --assume-yes install git curl cmake ninja-build clang uuid-dev libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython-dev libncurses5-dev pkg-config
    curl -O https://swift.org/builds/development/ubuntu1404/swift-DEVELOPMENT-SNAPSHOT-2016-04-25-a/swift-DEVELOPMENT-SNAPSHOT-2016-04-25-a-ubuntu14.04.tar.gz
   
    tar zxf swift-DEVELOPMENT-SNAPSHOT-2016-04-25-a-ubuntu14.04.tar.gz
    
    sudo chown -R vagrant:vagrant swift-*
   
    echo "export PATH=/home/vagrant/swift-DEVELOPMENT-SNAPSHOT-2016-04-25-a-ubuntu14.04/usr/bin:\"${PATH}\"" >> .profile
    echo "Swift has successfully installed on Linux"
  SHELL
end
