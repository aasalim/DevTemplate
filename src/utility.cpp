#include "utility.h"
int constrain(int value, int low, int high){
    return ((value)<(low)?(low):((value)>(high)?(high):(value)));
}