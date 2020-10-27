# urp-multi-pass

![](https://i.imgur.com/Lpt0XXJ.png)

I made this shader in order to practice in the transition from SRP to URP.

The focus of this project is NOT the shader itself, it is the implementation of a multi pass shader using Unity URP.

One of the difficulties I found when making this transition was how I couldn't just use SRP multi pass shaders in URP, as they wouldn't work as intended.
Instead, a multi-pass shader that would work without any problems using SRP, would only render the first pass.

Some research later and I found two working solutions and one workaround.

# Workaround using "LightMode"
This workaround is not recommended, but it can be useful to know this. This will allow you to have TWO passes in a shader. In the case of the shader used in this project, this workaround would be enough to make it work, as the specular pass can be easily be put in the diffuse pass. This is not the goal of this project, though, and I will still be using the specular in a different pass, so that you can see why this workaround is flawed.

To use this, you must use the "LightMode" in your first pass. I will use "UniversalForward". Only the FIRST pass with that tag will be rendered.

![](https://i.imgur.com/2abNWk5.png)

On the next pass you CANNOT add that tag, and this will allow you to render another pass. I'm using the outline pass in this example, and in the first image you can see it works.

![](https://i.imgur.com/yPlEtDr.png)

I also added a third pass, but it won't render, with or without the "LightMode" tag. The only way to render this pass is to run it instead of the Outline pass.

![](https://i.imgur.com/270DPLy.png)

# Solution #1 - Scriptable Render Passes

Using Scriptable Render Passes is a perfectly valid way of doing this, but I will tackle this on a different time. If you are interested in this method, I recommend [Brackeys' tutorial on Youtube](https://www.youtube.com/watch?v=szsWx9IQVDI).
This seems to be the best way if you don't know how to code, but it's not my favorite.

# Solution #2 - Multiple Materials

This solution, which is the one I used, requires you to use more than one material, each one being a pass. As the warning is pointing out below, all the materials will be applied to the same mesh, which is exactly what we want.

![](https://i.imgur.com/z52z9Wu.png)

This solution is quite straight forward. To do it, you only need to take each pass and split it into different shaders. You should have a material for each shader now, and you just need to add them into the materials array, in the Mesh Renderer component of your mesh.

This project is using the Creative Commons Zero v1.0 Universal license, so feel free to use, modify, et cetera, without needing to mention me or ask for permission, for personal or commercial purposes.
