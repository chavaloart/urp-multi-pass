# urp-multi-pass

![](https://i.imgur.com/9RbAbT4.png)

I made this shader in order to practice in the transition from SRP to URP.

The focus of this project is NOT the shader itself, it is the implementation of a multi pass shader using Unity URP.

One of the difficulties I found when making this transition was how I couldn't just use SRP multi pass shaders in URP, as they wouldn't work as intended.
Instead, a multi-pass shader that would work without any problems using SRP, would only render the first pass.

Some research later and I found two decent solutions.


The one I didn't use, uses Scriptable Render Passes, which is a perfectly valid way of doing this, but I will tackle this on a different time. If you are interested in this method, I recommend [Brackeys' tutorial on Youtube](https://www.youtube.com/watch?v=szsWx9IQVDI).

The one I used requires you to use more than one material, each one being a pass. As the warning is pointing out, all the materials will be applied to the same mesh, which is exactly what we want.

![](https://i.imgur.com/z52z9Wu.png)

This solution is quite straight forward. To do it, you only need to take each pass and split it into different shaders. You should have a material for each shader now, and you just need to add them into the materials array, in the Mesh Renderer component of your mesh.

*It should be pointed out that there are other ways of doing this, including ways in which you can have multiple passes in one shader, though this will require changes in the code. Check out [this shader](https://github.com/ColinLeung-NiloCat/UnityURPToonLitShaderExample) by Colin Leung, which has more than one pass in a shader.* 

This project is using the Creative Commons Zero v1.0 Universal license, so feel free to use, modify, et cetera, without needing to mention me or ask for permission, for personal or commercial purposes.
