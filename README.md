首先配置好matlab的调用接口。python版本和matlab版本是有一一对应关系的，否则无法建立联系，对应关系见下。
![image](https://github.com/whitekiral/0/assets/102890528/f639e6f1-52e7-40d5-b696-d003b898c103)

2.2 进行配置
matlab的安装方法就不累赘了，这里已默认你安装好了对应版本的matlab。
① 确定matlab安装路径
确认好matlab的安装路径，如若不清楚，可以打开matlab命令窗口输入matlabroot，如图

![image](https://github.com/whitekiral/0/assets/102890528/9b9da44e-b93f-4167-afbc-a64e2a29b6a6)

笔者的安装路径为C:\Program Files\MATLAB\R2019b。
② matlab里面找到python engine
大部分python库都是通过pip来安装的，而matlab自R2014b以后引入了MATLAB engine这一功能, 提供了对Python的支持，matlab.engine的安装不是通过pip安装的。
在上述步骤①中的matlab的安装路径里找到： matlab安装路径\extern\engines\python，笔者是C:\Program Files\MATLAB\R2019b\extern\engines\python，进入路径见下图，发现里面有个python，点开python里面有个setup.py。

![image](https://github.com/whitekiral/0/assets/102890528/160da60b-b395-4158-bc51-5319c8f93691)

③ anaconda方法配置连接
在上述①和②步骤找到的python engine路径，即matlab安装路径\extern\engines\python，笔者的是C:\Program Files\MATLAB\R2019b\extern\engines\python，在anaconda中确定该位置，方法如下：
打开anaconda下面的anaconda prompt,进入到了anaconda prompt 之后键入如下语句

![image](https://github.com/whitekiral/0/assets/102890528/13cce5cf-dcde-4586-81fe-455099c56e0c)

enter确认后，我们发现anaconda prompt已经进入了python engine 路径，，在后面输入语句，见下面的图，enter 确认。

![image](https://github.com/whitekiral/0/assets/102890528/92d2677e-65ea-40f0-ad61-d0a20011907c)

enter确认后发现anaconda prompt界面运行一堆语句，咱不用管，见下运行过程

![image](https://github.com/whitekiral/0/assets/102890528/6e089204-f1d1-40a0-b7f1-3ee7ed4357df)

拖到运行的最后部分，............R2019a-py3.6.egg-info，这告诉我们python3.6解释器可以调用matlab了.
配置好了matlab的调用环境之后，得按照requirement.txt里面的要求安装对应的软件包。

![image](https://github.com/whitekiral/0/assets/102890528/8d661e4c-a16f-4e22-87a7-d03aad47f3c8)

其中tensorflow必须装2.10.0及以下的，否则无法调用了gpu。

![image](https://github.com/whitekiral/0/assets/102890528/28264eaf-8b5e-4d85-8383-8b27238c218a)

打开频散曲线的自动的提取文件。

![image](https://github.com/whitekiral/0/assets/102890528/0c9227a0-bd7b-4c7a-921a-7aca62cde43e)

自行设置框起来部分的参数，包括设置速度区间及周期区间以及插值频率以及最小信噪比等。

![image](https://github.com/whitekiral/0/assets/102890528/5af8b4c6-e443-4c30-9798-d661ab305631)

设置好互相关文件数据的路径，笔者路径是C:\ascii。然后点击运行即可在所在文件夹下面生成对应的提取的频散曲线。如下图所示

![image](https://github.com/whitekiral/0/assets/102890528/4246284b-c7fa-4863-a128-ca5b768d4a3d)

群速度频散曲线存储在disperg文件夹下面。相速度频散曲线存储在disperp文件夹下面。

![image](https://github.com/whitekiral/0/assets/102890528/43220a61-581c-45a8-9e31-a09353ceea39)

点击运行对应的文件转换部分，可将提取到的频散曲线存储为反演所需要的txt文件存储内容也和手动提取的一样。

![image](https://github.com/whitekiral/0/assets/102890528/ffd23bb6-179b-40fa-a7ec-a76b91822841)

此为自动提取出来的群速度频散曲线。

![image](https://github.com/whitekiral/0/assets/102890528/eb0c54a6-60ed-4f61-b904-277a9384e2a6)

此为自动提取出的相速度频散曲线。

![image](https://github.com/whitekiral/0/assets/102890528/883b67dd-009a-4165-9cfb-e5066d784e63) ![image](https://github.com/whitekiral/0/assets/102890528/f7224be3-9565-43ca-9fce-b20fabb06454)

此为对应输出的概率图。

![image](https://github.com/whitekiral/0/assets/102890528/4194c80e-c6a0-4749-a282-8000fdbb0ea6) ![image](https://github.com/whitekiral/0/assets/102890528/f0c030e9-28bc-4af0-87ef-1f5cab0d6432)

此为对应的频散曲线自动提取效果，黑色及绿色线表示信噪比阈值。

![image](https://github.com/whitekiral/0/assets/102890528/fb39f317-59df-4069-8dc6-fcb90b70d04e) ![image](https://github.com/whitekiral/0/assets/102890528/13a66c8c-2da6-4614-93bd-d2747a1e233b)

![image](https://github.com/whitekiral/0/assets/102890528/651ff6a4-38ad-4d0a-9649-afdceb7a685f) ![image](https://github.com/whitekiral/0/assets/102890528/9cdea391-e649-429c-a93c-7d079392c210)

频散曲线自动提取效果图，手动提取和自动提取的对比。











