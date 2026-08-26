# 通用工作原则与编码习惯

对所有项目生效的个人习惯与通用工程原则。特定技术栈的专属约定放在同目录的私有规则里，仅在配了私有 submodule 的机器上加载。

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

## 注释

### 1. 核心原则：解释「为什么」，不解释「做了什么」
- **[强约束] 严禁逐行翻译代码语法**（严禁「定义变量 x 并赋值为 1」这类）。
- 重点写：业务背景、非直觉的设计抉择、边缘情况、算法依据、外部约束（第三方的行为、平台限制）。
- 代码本身说得清的、翻官方文档能查到的，都不写。
- **写这行代码做什么，不写它相对什么变了。**「上游默认是 X」「原来的值是 Y」「显式写出来防止上游改默认」属于 commit message。

### 2. 函数 / 方法级注释
- 公共函数、类、接口必须有该语言标准的结构化文档注释（JSDoc / Python Docstring 等）。
- 必须包含：功能简述、`@param`、`@return`、`@throws`。
- 内部简单辅助函数不需要。

### 3. 行内注释
- 仅在逻辑极复杂、有历史兼容代码、或有特定坑点时添加，绝不多写一行无意义的。
- 只写职责边界，不写另一侧的实现细节——写「tab 交给 tmux」可以，写「prefix C-s」会造成跨文件耦合。
- 删掉的代码不需要注释交代，那是 git history 的事；整段只剩注释就把整段删掉。
  例外：主动关掉某个默认行为时（如一批 `no_op`）要说明为什么关，否则后来看会以为多余。

### 4. 待办与特殊标记
- 统一用大写前缀：`TODO:` 待完成的功能或后续重构、`FIXME:` 已知 Bug 或边界风险、`HACK:` 为兼容性或紧急上线写的临时方案。

### 5. 排版
- **一行一句。** 不要把一个句子按列宽折成多行——每行单独看都要成立。并列内容用对齐的缩进列表，不用连续散文。
- 注释单独成行，不写在代码行尾。
- 一组同类的一行注解合并成一块，代码跟在下面；不要一行注释一行代码。
- 注释紧挨它描述的那段代码，不要隔着别的语句。
- 一个文件内首字母大小写与句末标点保持一致；以标识符开头时保持原样，不要为了句式大写它。

### 6. 语言
- 默认中文，技术专有名词保留英文；语言简练直接，不写客套话。
- 已有文件跟随其现有语言，一个文件内不混用。

## 写进仓库的文件
- 内容必须对任何机器成立。「我这台现在是什么」是观察，不是事实。
- 需要指路径 / 取值时写获取方法（`git config --get`、环境变量、`$(command)`），不写字面值。
- 提交前 grep 一遍暂存区：绝对路径（`/Users/`、`/home/`）、主机名、「本机 / 这台 / 当前是」、装在本机的软件版本号。

## Git
- 写 commit message 前先读一遍模板：路径用 `git config --get commit.template` 取，按模板里的约定写。不要凭记忆。
- **署名尾行（`Co-Authored-By`）每次提交前主动问**，不要自己决定加或不加。已有惯例是 `Co-Authored-By: Claude Opus <版本> <noreply@anthropic.com>`。

## 安全
- **不读取密钥 / 证书文件**：私钥、证书、各类服务商凭证。需要时只看目录结构或 README，不用 Read / cat / grep 碰内容。

## 并发安全（读-改-写禁令）
- 库存 / 计数器 / 余额等**并发敏感字段**的写入，必须用数据库层的**原子操作**：带条件的 update，把「够不够」写进条件里。
- 禁止「先读出值 → 算新值 → 写回」的三段式。检查与使用之间存在 TOCTOU 窗口，会超卖、双花、丢计数。
- 预读只能用来优化错误提示（区分「不存在」和「不足」），不能作为正确性依据。真正的判断放在那次原子 update 的条件里，靠受影响的记录数判成功。
- 跨表 / 跨集合协同（如归还库存：扣 A → 加 B）必须先原子扣 A、成功后再操作 B，不能反过来。

## 时区
- 服务端日期逻辑，**输入（读当前时间）和输出（转换/存储）两端都要显式处理时区**。
- 不要假设进程读到的当前时间就是业务时区，先转成业务时区再做日期运算。
- 「服务器时区 = 业务时区」是巧合不是保证。

## 已上线接口的向后兼容
- 改**已上线**的接口时，**默认行为不能变**——旧版客户端仍在用户设备上运行，不会传新参数。加新能力要用纯增量：保留原默认值和原有分支，新增一个显式取值来开新逻辑。
