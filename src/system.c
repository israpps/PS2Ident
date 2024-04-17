#include <kernel.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <dirent.h>

#include "system.h"

extern void *_gp;

int GetBootDeviceID(void)
{
    static int BootDevice = -2;
    char path[256];
    int result;

    if (BootDevice < BOOT_DEVICE_UNKNOWN)
    {
        getcwd(path, sizeof(path));

        if (!strncmp(path, "mc0:", 4))
            result = BOOT_DEVICE_MC0;
        else if (!strncmp(path, "mc1:", 4))
            result = BOOT_DEVICE_MC1;
        else if (!strncmp(path, "mass:", 5) || !strncmp(path, "mass0:", 6))
            result = BOOT_DEVICE_MASS;
        else if (!strncmp(path, "host:", 5) || !strncmp(path, "host0:", 5))
            result = BOOT_DEVICE_HOST;
        else
            result = BOOT_DEVICE_UNKNOWN;

        BootDevice = result;
    }
    else
        result = BootDevice;

    return result;
}

int SysCreateThread(void *function, void *stack, unsigned int StackSize, void *arg, int priority)
{
    ee_thread_t ThreadData;
    int ThreadID;

    ThreadData.func             = function;
    ThreadData.stack            = stack;
    ThreadData.stack_size       = StackSize;
    ThreadData.gp_reg           = &_gp;
    ThreadData.initial_priority = priority;
    ThreadData.attr = ThreadData.option = 0;

    if ((ThreadID = CreateThread(&ThreadData)) >= 0)
    {
        if (StartThread(ThreadID, arg) < 0)
        {
            DeleteThread(ThreadID);
            ThreadID = -1;
        }
    }

    return ThreadID;
}
