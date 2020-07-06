TEMPLATE = subdirs

ThirdLibrary.file = ThirdLibrary/RabbitThirdLibrary.pro
RabbitCommon.file = ThirdLibrary/RabbitCommon.pro
RabbitImLib.file = RabbitImLib.pro
RabbitImLib.depends = RabbitCommon
Plugin.depends = RabbitImLib
RabbitImApp.file = App/RabbitImApp.pro
RabbitImApp.depends = RabbitCommon RabbitImLib Plugin

CONFIG *= ordered
SUBDIRS *= ThirdLibrary \
    RabbitCommon \
    RabbitImLib \
    Plugin \
    RabbitImApp

OTHER_FILES += README.md \
    share/applications/* \
    .gitignore \
    .travis.yml \
    ci/* \
    circle.yml \
    appveyor.yml \
    debian/* \
    AppIcon.rc \
    Resource/translations/*.ts \
    docs/* \
    docs/Books/* \
    docs/QXmpp音视频呼叫流程.txt \  
    docs/RabbitImServer/* \
    License.md \
    ChangeLog.md \
    Authors.txt \
    TODO.txt \
    CMakeLists.txt \
    cmake/* \
    cmake/platforms/* \
    platforms/android/* \
    Update/*template* \
    Update/*.xml \
    Doxyfile* \
    pri/* \
    Install/* \
    Dockerfile \
    tag.sh \
    build_debpackage.sh
