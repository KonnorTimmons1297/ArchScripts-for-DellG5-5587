# Scripts that I created for Arch linux on my DellG5-5587
Here are some scripts that I created to make using Arch on my Dell G5 5587 a little easier.

## Gamemode Scripts ##
Scripts that prepare your machine for playing games.

In my case, I have an SSD and a traditional Hard Drive. I have Arch on my SSD and all of my games are on my hard drive.

### Game mode start script(GameModeStart) ###
1. Run checks for `Bumblebee` service.
2. Check to make sure that ~/Games has the correct permissions
    1. I mount my hard drive to `~/Games`
3. Check the loaded modules to see if nvidia is loaded
    1. If they aren't loaded, then try and load them.
    2. This generally fails though. More on that in the `nvidia-xrun` section
4. Check the current operating mode of the cpu
5. Set performance mode for hard drive
    1. Using `hdparm`

### Game mode stop script(GameModeStop) ###
1. Remove the loaded nvidia modules and check that it is off
    1. Using `bbswitch`
2. Change the CPU governor mode back to powersave
3. Turn on agressive power saving for hard drive
    1. Using `hdparm`

## nvidia-xrun ##
The Dell G5 15 5587 using optimus graphics. My machine has an iGPU and dGPU. The iGPU is an intel iris 630, and the dGPU is an Nvidia GTX 1050 Ti.

To utilize the dGPU I was unable to use Bumblebee and bbswitch in conjunction with optirun or primusrun. Instead I found that the [nvidia-xrun](https://github.com/Witko/nvidia-xrun) method works flawlessly.

I use this method in conjunction with the two previous scripts that I created. 