

# SignalHandler

[![Ubuntu](https://github.com/cppmf/SignalHandler/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/cppmf/SignalHandler/actions/workflows/ubuntu.yml)
[![MacOS](https://github.com/cppmf/SignalHandler/actions/workflows/macos.yml/badge.svg)](https://github.com/cppmf/SignalHandler/actions/workflows/macos.yml)
[![Windows](https://github.com/cppmf/SignalHandler/actions/workflows/windows.yml/badge.svg)](https://github.com/cppmf/SignalHandler/actions/workflows/windows.yml)

[![codecov](https://codecov.io/gh/cppmf/SignalHandler/branch/master/graph/badge.svg?token=HK6YTUCDUC)](https://codecov.io/gh/cppmf/SignalHandler)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=cppmf_SignalHandler&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=cppmf_SignalHandler)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=cppmf_SignalHandler&metric=coverage)](https://sonarcloud.io/summary/new_code?id=cppmf_SignalHandler)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=cppmf_SignalHandler&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=cppmf_SignalHandler)


Simple multiplatform signal handler

# Usage

```cpp
#include <sh/SignalHandler.h>
#include "MyApp.h"

int main ()
{
    MyApp myApp;
    ...
    sh::SignalHandler handler({SIGINT}, &MyApp::onSignal);

    return myApp.run();
}
```