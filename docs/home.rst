.. Comment

    # with overline, for parts
    * with overline, for chapters
    =, for sections
    -, for subsections
    ^, for subsubsections
    “, for paragraphs



#########
Labmanual
#########


The purpose of this page is to provide information and insight into the
my computing configuration, lessons learned, and preferences in
prototyping development based on my experience as designer and developer of
prototype systems in a product-tracked research environment.



General Philosophy
------------------

1. Iterate
2. Isolate
3. Modularize


Iterate
```````

Nothing is perfect the first time around. This applies to any field, even my
own journey in learning these lessons. Thus, it is important to be aware that
development of anything is an iterative process. The first draft will always be
poor in comparison to the final product, so do not get yourself down about it.
Remember that as something is developed, it will be improved, and that through
development you will learn how to improve the system and yourself.

Keep in mind that iteration will take time, and a good practice is to account for
multiple iterations of development. This first inline with a research and
prototype development cycle wherein a problem is firstly defined, background
researched is conducted, multiple ideas are proposed, a comparison is conducted,
a prototype path is chosen, and development begins. At any point of the cycle
it may be necessary to come back to the drawing board and update the problem
definition of potential solutions. This is the natural process.

Isolate
```````

Isolate development modules and systems from each other. Use robust interfaces
between systems, avoid co-dependence when possible.

Isolate systems through virtual environments, virtual machines, and containers.
This will also ensure all modules and software developed will run on the same
base operating system. Further, it also provides a quick method to rebuild
complete systems without affecting host computer, and there is *generally* no
worries that a system under development will harm the host.

Modularize
``````````

Build all components in modular fashion, try to maximum isolation between modules
to reduce interdependencies. This applies to Object Oriented Programming,
especially in *Interface* classes and *derived* classes, as the *Interfaces*
should have **no** knowledge of specific members and methods of the *derived*
classes.


Prototype Code Development
--------------------------

I highly recommend reading a clean coding practices text at some point (ideally,
as early as possible). Personally, I should have read one much earlier in my
career - however being self-taught in programming, it took a while to get to :)

Herein, I will refer to *Clean Code* by Robert C. Martin for in depth reading,
however, I will summarize my take-away points that I try to follow. The text
provides much more context and situational examples.

1. Clean & Clear
2. Test
3. Web


Clean & Clear
`````````````

Clean and clear code will mean its... **legible**.

Apply standards -> i.e. PEP8, etc.

Naming -> descriptive
       -> case type flows standards

Comments
- do not comment obvious lines
- with clear naming no need to comment variables
- use domain-specific language in descriptive/functional comments i.e. math



Do One Thing (DOT)
- split functions
- reduce input arguments (increases testing complexity)
- avoid at all costs passing booleans (violates DOT)
- avoid returns through input arguments
- avoid returning arguments (use class members) unless necessary
-

documentation
- Generally, good naming and DOT principles will make the code self-descriptive
however, in a world where a well written domain specific description is required,
it is best to integrate auto-doc comments, i.e. doxygen
- Very important to keep this documentation aligned with code, otherwise, either
the code or the commentry will be lying about the underlying implementation

Test
````

I am late to the game of testing, I'll admit this openly. Testing in a
research prototyping environment has always been ad hoc and difficult to control.
However, it is not impossible,

Web
```

Build interfaces for Web. Browser developers have spent a lot more time developing
good graphical interfaces for users with many issues resolved, thus, why not
use the most common GUI application there is? Develop applications that take
advantage of web-based front end, thus avoiding developing your own front end.

I have found myself many times struggling with creating a GUI application,
specifically, choosing a back end, learning the library, considering portability,
and actually developing. In contrast, it always made more sense to simply develop
the backend as needed, and provide a web-facing interface for any GUI
requirements.

The beauty of a web-based front end is that there are so many tools and guides
available for development (mostly rooted in JavaScript from my perspective), and
they will almost always work off the bat with any device, and as a bonus point,
if your application is running on a networked machine, the GUI could be accessible
remotely! (my favourite part, especially when working with many headless devices)


Configurations
--------------

*~~~~ under construction ~~~~~~*

Host Operating Systems:

I mostly use macOS for development and update to latest OS release about 6-8 months
after it is released to public and many companies update their software to
support the latest OS.

I also use Linux for virtual machines and the base of docker images.

- [ ] Mac
  - [ ] brew
- [ ] Linux

- [ ] PyCharm & Clion

- [ ] Host + Virtual Environments
- [ ] Host + Docker + (remote vis?)

Ideally, when using **Isolation**, the host configurations are fairly minimal
since there is no need to worry about required dependencies - these are taken
care of by the isolated system, either through python virtual environments, or
through docker containers.

Personally, I use macOS and Linux when necessary.

- zsh, screen, vim (learning in progress w/ plugins to replace IDE's)
- pycharm, clion, webstorm
- atom / sublime

Docker Container
````````````````

I created a docker file along side a python requirements file that provides and
installs everything I need to do the various development. This docker image
is not meant for deployment as it is rather large and simply provides an
**isolated** environment for my development.

It is noted, that for certain requirements, i.e. pytorch, the default
docker configuration may require more memory, otherwise the build could exit with
code 139.
