
#include "sh/SignalHandler.h"
#include <future>

namespace sh {

SignalHandler* SignalHandler::instance = nullptr;

SignalHandler::SignalHandler() {
    instance = this;
}

SignalHandler::SignalHandler(int signum, const std::function<void()>& handler) {
    instance = this;
    handle(signum, handler);
}

SignalHandler::SignalHandler(const std::initializer_list<int>& signums, const std::function<void()>& handler) {
    instance = this;
    handle(signums, handler);
}

void SignalHandler::onSignal(int signum) {
    for(const auto& holder : instance->holders) {
        if(holder.first == signum) {
            holder.second();
            if(signal(signum, onSignal) == SIG_ERR) {
                throw SignalException();
            }
        }
    }
}

void SignalHandler::handle(int signum, const std::function<void()>& handler) {
    if(signal(signum, onSignal) == SIG_ERR) {
        throw SignalException();
    }
    else {
        holders.emplace_back(std::make_pair(signum, handler));
    }
}

void SignalHandler::handle(const std::initializer_list<int>& signums, const std::function<void()>& handler) {
    for(auto signum : signums) {
        handle(signum, handler);
    }
}

} // namespace sh
