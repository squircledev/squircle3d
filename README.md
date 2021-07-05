# squircle3d
 hopefully easy 3d in game maker

# who is this for

this is for me, the developer, squircledev. however, i'm posting this publicly because 3D in GameMaker is something that is pretty unexplored. everything in this library is tuned for my specific use case (low poly. no materials, low fidelity everything in general) and not for much of anything else. 

if you wanted to learn 3d in GM, im hoping this can kind fo give you a head start. and then maybe you can fix, change, whatever. a lot of the content of this library is based on the book [Real-Time Collision Detection](https://www.amazon.com/Real-Time-Collision-Detection-Interactive-Technology/dp/1558607323) but some of it isnt. feel free to contact me if youre curious about where i got something

# what are the terms of usage

steal code, yoink it, whatever you call it. credit would be nice but i don't care. i just want more 3d GM games lol. i hope you find this useful!

# features

### here's what this 3d "library" of mine contains:
- bugs
- inaccurate and/or poorly performing implementations
- collision detection for aabbs, spheres, tris, capsules, and segments/lines/rays
- collision mesh for somewhat performatively checking against level geometry
- basic 3d camera system
- support for baked 3d animations and interpolating between frames for 60fps+ animations even with few frames of animation
- shaders which do the following:
  - interpolate frames of animation
  - add an outline to the model
  - add subtle shading
  - adjust uvs so that you dont need to do separate texture pages for sprites

### here's what it does not contain at the moment, but will at some point as i need it for my current projects:
- collision detection for capsules, spheroids, and other useful shapes
- collision response helpers (currently not all of the collision detection functions return things that allow you to perform good collision response)
- basic skeletal animation

### here's what it will maybe contain if I feel like it:
- octrees for the collision meshes
- dynamic shadows, lighting, etc

### here's what it will probably never contain:
- advanced 3d rendering such as materials, normal mapping, and so on. this is for low poly / retro aesthetics and will probably stay that way! there are other more fully featured libraries for this
- advanced skeletal animation to where baking animations is obsolete (harder to implement than i thought. too many bones in the rigs i like to use so... yeah)

# pull requests?

no, probably not. id rather you just make your own fork, your own library, whatever. feel free to use mine as a complete base for it, but i will be changing this for my specific uses over time.
