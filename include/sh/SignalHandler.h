#pragma once

#include "sh/export.h"

// Required Inclusions
#include <csignal>
#include <functional>
#include <stdexcept>
#include <vector>

namespace sh {

class SignalException : public std::runtime_error
{
public:
    SignalException()
      : std::runtime_error("Error setting up signal handlers !") {}
};

/**
 * Simple signal handler
 */
class SignalHandler
{
public:
    SignalHandler();
    SignalHandler(int signum, const std::function<void()>& handler);
    SignalHandler(const std::initializer_list<int>& signums, const std::function<void()>& handler);
    ~SignalHandler() = default;

    SignalHandler(const SignalHandler& other) = delete;
    SignalHandler(SignalHandler&& other) = delete;
    SignalHandler& operator=(const SignalHandler& other) = delete;
    SignalHandler& operator=(SignalHandler&& other) = delete;

    void handle(int signum, const std::function<void()>& handler);
    void handle(const std::initializer_list<int>& signums, const std::function<void()>& handler);

protected:
    static void onSignal(int signum);

private:
    typedef std::pair<int, std::function<void()>> SignalHolder;

    std::vector<SignalHolder> holders;
    static SignalHandler* instance;
};

} // namespace sh
