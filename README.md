Simple Deployer

**Usage**

To run using a config file named config.yml in the same directory
    
    $ cli_deployer
    
To run specifiying a config

    $ cli_deployer /path/to/my_config.yml
      
**Why**

I no longer needed a continuos integration environment, so no more Jenkins!
 
In the time it would take to find something else that did what I needed, I could write my own deployer.

**Is this better than Jenkins or other deployment software?**
Probably (definitely) not.

**Why would you want to use this?**

Because you don't want the overhead of jenkins and you don't want to manage and configure a bunch of stuff just to deploy some simple apps.

Look at example.yml for a simple example configuration

**Notes**

This assumes you are using ssh keys for scp and ssh.  Passwords are not supported, but would be easy to add


**Usage**
The program looks at your config file (config.yml in the same dir as default) and then provides a command line interface to run a number of shell commands to clone, build, and deploy the application.
example.yml provides the expected format along with sample values for all stages of processing.

The first step is to ask which application you want to work on

**TODO**

add more usage instructions
 
provide better error message

add support for passwords

improve the command line and ssh command chaining

make it useful for at least one other person than me

turn it into a gem

