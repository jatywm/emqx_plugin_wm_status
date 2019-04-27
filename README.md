
emqx_plugin_wm_status
====================

## emqx 插件 
ClinetID 上下线 同步到Redis

## 编译发布插件
### 1.clone 项目:

```
git clone https://gitee.com/i3cloud/emqx_plugin_wm_status.git
```
## 2.make编译:

## 3.relx.config 中 release 段落添加:

```
{emqx_plugin_wm_status, load}
```
