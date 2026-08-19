# 通用工作原则与编码习惯

对所有项目生效的个人习惯与通用工程原则。（公司 / CloudBase 技术栈专属约定放在同目录的私有 `cloudbase` 规则里，仅在配了私有 submodule 的机器上加载。）

> 下面 1-4 条源自 Andrej Karpathy 对 LLM 编码通病的总结，偏向「稳」而非「快」；琐碎任务（改错别字、明显的一行改动）自行把握，不必套全套。

## 1. Think Before Coding
**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First
**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes
**Touch only what you must. Clean up only your own mess.**

- Don't "improve" adjacent code, comments, or formatting; don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.
- Remove imports/variables/functions that YOUR changes made unused; don't remove pre-existing dead code unless asked.
- The test: every changed line should trace directly to the user's request.
- 改动的连带影响：修改共享工具函数的返回结构（加字段/改名/语义变化）时，先 grep 所有 caller 逐个同步，不能只改被提到的那个。推荐 caller 用 `...obj` 展开整个返回对象、而非解构单独字段，util 加字段时 caller 自动跟上。

## 4. Goal-Driven Execution
**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

多步任务先给一段简短计划（每步带验证）：
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
```
Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

## 代码风格
- 函数**参数 >1 个时用对象解构**（named parameters）：`function foo({ a, b })`，调用方也对应 `foo({ a, b })`。单参数不变。
- **文件内结构顺序**：imports → 常量 → 函数（上层/导出函数在前，其调用的子函数紧跟其后）→ exports。多个文件重复的通用方法提取到 `utils/common.js`。
- **package.json 依赖用确切版本**（如 `"2.30.0"`），不带 `^` 或 `~`。

## Git
- commit message **不要**加 `Co-Authored-By` 尾行。

## 安全
- **不读取密钥/证书文件**（如 `certs/` 下的 `.pem`、各类私钥、支付宝/微信商户凭证）。需要时只看目录结构或 README，不用 Read/cat/grep 碰凭证内容。

## 并发安全（读-改-写禁令）
- 库存/计数器/余额等**并发敏感字段**的写入，必须用数据库层**原子操作**（带条件的 update，如 `.where({ field: _.gte(n) }).update({ field: _.inc(-n) })`），禁止「先 get 读出值 → 算新值 → update 写回」的三段式——检查与使用之间存在 TOCTOU 窗口，会超卖/双花/丢计数。
- 预检查 `get()` 只能用于优化错误提示（区分"不存在"vs"不足"），不能作为正确性依据；真正的判断放进最终原子 update 的 where 里，靠 `updated === 1` 判成功。
- 多集合协同（如归还库存：扣 A → 加 B）必须先原子扣 A、成功后再操作 B，不能反过来。

## 时区
- 服务端日期逻辑，**输入（读当前时间）和输出（转换/存储）两端都要显式处理时区**。不要假设 `new Date()` 等于业务时区——先把 `new Date()` 转成业务时区再做日期运算（如 `utcToZonedTime(new Date(), TZ)`）。「服务器时区 = 业务时区」是巧合不是保证。

## 已上线接口的向后兼容
- 改**已上线**的云函数/API 接口时，**默认行为不能变**——客户端（小程序等）有历史版本仍在用户设备上运行，旧版本不会传新参数。加新能力要用纯增量：保留原默认值和原有分支，新增一个显式取值（如 `soldOut: 'all'`）来开新逻辑。
