# Robotics-Simulations-in-V-Rep-using-Matlab
Robotics simulation is one of the most important tasks in robotics. Pre-requisite of a robotics project is simulation. In the task of simulation, v-rep is a favorable choice as it has nice interactive environment. Moreover, v-rep is flexible with language. One can code in python, lua, or matlab etc. Here it is a repository where I keep all of my v-rep simulations in robotics.


# Requirements 
* Matlab 18 or above (not sure, i ran it on Matlab 19b)
* CoppeliaSim Edu (V-rep)

# Getting Started 
* Firstly, clone the repository by downloading zip file or by cloning in cmd prompt. 
* To run Obstacle avoidance code, first open obstacleavoidance.ttt and start simulation then open obstacleavoidance.m file and run the code to see simulation on v-rep environment.
N.B : Don't forget to add a code snippet 
```bash
if (sim_call_type==sim_childscriptcall_initialization) then
	simExtRemoteApiStart(19999)
end
```
In the non threaded child script of Cuboid object in V-rep simulator to make it function properly.
