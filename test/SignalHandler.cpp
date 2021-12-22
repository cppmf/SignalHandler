
#include <atomic>
#include <catch2/catch.hpp>
#include <chrono>
#include <iostream>
#include <thread>
#include <sh/SignalHandler.h>

#ifdef WIN32
#    include <windows.h>
#else
#    include <unistd.h>
#endif

using namespace sh;

std::atomic<bool> running = true;

void on_signal() {
    running.store(!running);
}

TEST_CASE("SignalHandler_constructors") {

    SECTION("Constructor_default") { SignalHandler sh; }

    SECTION("Constructor_simple") { SignalHandler sh({SIGINT}, nullptr); }

    SECTION("Constructor_multiple") { SignalHandler sh({SIGINT, SIGINT}, nullptr); }
}

TEST_CASE("SignalHandler") {

    SignalHandler sh({SIGINT}, on_signal);

    CHECK(running.load() == true);
#ifdef WIN32
    GenerateConsoleCtrlEvent(CTRL_C_EVENT, 0); // SIGINT
#else
    kill(getpid(), SIGINT);
#endif

    std::this_thread::sleep_for(std::chrono::seconds(1));

    CHECK(running.load() == false);
}
