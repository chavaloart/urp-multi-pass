# urp-multi-pass

![](https://i.imgur.com/9RbAbT4.png)

I made this shader in order to practice in the transition from SRP to URP.

The focus of this project is NOT the shader itself, it is the implementation of a multi pass shader using Unity URP.

One of the difficulties I found when making this transition was how I couldn't just use SRP multi pass shaders in URP, as they wouldn't work as intended.
This lead me to research about this, and I found some solutions. My favorite solution, and simpler by far, was to use more than one material on the mesh renderer.

![](https://i.imgur.com/z52z9Wu.png)

This solution still requires changes to be made in the shader code, but since it is mostly dividing the different passes into new shaders, it is also quite straight forward.

This project is using the Creative Commons Zero v1.0 Universal license.
