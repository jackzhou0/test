FROM xzhou001/android:33-jdk17
RUN export PATH=$PATH:/klocwork/kwbuildtools/bin
RUN curl -sSLO https://download.oracle.com/java/17/archive/jdk-17.0.12_linux-x64_bin.tar.gz
RUN tar -zxvf jdk-17.0.12_linux-x64_bin.tar.gz
RUN export JAVA_HOME=$PWD/jdk-17.0.12
RUN export PATH=$PATH:$JAVA_HOME/bin
RUN export CLASSPATH=.:$JAVA_HOME/jre/lib
RUN apt-get update -y
RUN export ANDROID_HOME="/opt/android-sdk-root"
RUN echo $ANDROID_HOME
RUN install -d $ANDROID_HOME
RUN wget --no-verbose --output-document=$ANDROID_HOME/cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
RUN unzip -q -d "$ANDROID_HOME/cmdline-tools" "$ANDROID_HOME/cmdline-tools.zip"
RUN mv -T "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/tools"
RUN export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/platform-tools/
RUN sdkmanager --version
RUN yes | sdkmanager --licenses > /dev/null || true
RUN sdkmanager "platforms;android-33"
RUN sdkmanager "platform-tools"
RUN sdkmanager "build-tools;33.0.2"
RUN apt-get install libx11-dev libpulse0 libgl1 libnss3 libxcomposite-dev libxcursor1 libasound2 --yes
RUN sdkmanager --sdk_root=/opt/android-sdk-root "emulator" "system-images;android-33;default;x86_64"
RUN wget --quiet --output-document=android-wait-for-emulator https://raw.githubusercontent.com/travis-ci/travis-cookbooks/0f497eb71291b52a703143c5cd63a217c8766dc9/community-cookbooks/android-sdk/files/default/android-wait-for-emulator
RUN add-apt-repository ppa:bastif/google-android-installers
RUN apt update -y
RUN apt install google-android-cmdline-tools-12.0-installer google-android-emulator-installer -y
RUN chmod +x android-wait-for-emulator
RUN sdkmanager --list
RUN ls -lha
RUN export ANDROID_SDK_ROOT=/opt/android-sdk-root
RUN echo no | /opt/android-sdk-root/cmdline-tools/tools/bin/avdmanager create avd --force -n myavd -k "system-images;android-33;default;x86_64"
RUN emulator -list-avds
CMD [ "bash" ]
