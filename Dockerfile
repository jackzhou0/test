FROM xzhou001/android:33-jdk17
RUN echo $ANDROID_HOME
RUN apt-get install libx11-dev libpulse0 libgl1 libnss3 libxcomposite-dev libxcursor1 libasound2 --yes
RUN sdkmanager --sdk_root=$ANDROID_HOME "emulator" "system-images;android-33;default;x86_64"
ENV PATH=$PATH:$ANDROID_HOME/emulator
RUN wget --quiet --output-document=android-wait-for-emulator https://raw.githubusercontent.com/travis-ci/travis-cookbooks/0f497eb71291b52a703143c5cd63a217c8766dc9/community-cookbooks/android-sdk/files/default/android-wait-for-emulator
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:bastif/google-android-installers
RUN apt update -y
RUN chmod +x android-wait-for-emulator
RUN sdkmanager --list
RUN ls -lha
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
RUN echo no | avdmanager create avd --force -n myavd -k "system-images;android-33;default;x86_64"
RUN avdmanager list avd
CMD [ "bash" ]
