return {
  {
    "nvim-mini/mini.icons",
    lazy = false,
    priority = 999,
    opts = {
      extension = {
        -- C# / .NET
        razor = { glyph = "﹫", hl = "MiniIconsPurple" }, -- Blazor Components (.razor)
        cshtml = { glyph = "﹫", hl = "MiniIconsPurple" }, -- MVC/Razor Pages (.cshtml)
        cs = { glyph = "󰌛", hl = "MiniIconsGreen" }, -- C# Code (.cs)
        csproj = { glyph = "󰪮", hl = "MiniIconsOrange" }, -- C# Project (.csproj)
        sln = { glyph = "󰪮", hl = "MiniIconsOrange" }, -- Solution (.sln)

        -- Typescript
        ts = { hl = "MiniIconsMarine" },
      },
      directory = {
        -- ╔══════════════════════════════════════════╗
        -- ║         MVC / WEB FRAMEWORKS             ║
        -- ╚══════════════════════════════════════════╝

        -- Controllers (Controle/Gamepad)
        controllers = { glyph = "󰊗", hl = "MiniIconsRed" },
        Controllers = { glyph = "󰊗", hl = "MiniIconsRed" },
        controller = { glyph = "󰊗", hl = "MiniIconsRed" },
        Controller = { glyph = "󰊗", hl = "MiniIconsRed" },

        -- Models (Estrutura de dados/Cubos)
        models = { glyph = "󰆧", hl = "MiniIconsBlue" },
        Models = { glyph = "󰆧", hl = "MiniIconsBlue" },
        model = { glyph = "󰆧", hl = "MiniIconsBlue" },
        Model = { glyph = "󰆧", hl = "MiniIconsBlue" },

        -- Views (Visão)
        views = { glyph = "󰊸", hl = "MiniIconsGreen" },
        Views = { glyph = "󰊸", hl = "MiniIconsGreen" },
        view = { glyph = "󰊸", hl = "MiniIconsGreen" },
        View = { glyph = "󰊸", hl = "MiniIconsGreen" },

        -- Services (Serviços/Engrenagens rodando)
        services = { glyph = "󰢏", hl = "MiniIconsPurple" },
        Services = { glyph = "󰢏", hl = "MiniIconsPurple" },
        service = { glyph = "󰢏", hl = "MiniIconsPurple" },
        Service = { glyph = "󰢏", hl = "MiniIconsPurple" },

        -- Middleware (Camadas intermediárias)
        middlewares = { glyph = "󰍜", hl = "MiniIconsYellow" },
        Middlewares = { glyph = "󰍜", hl = "MiniIconsYellow" },
        middleware = { glyph = "󰍜", hl = "MiniIconsYellow" },
        Middleware = { glyph = "󰍜", hl = "MiniIconsYellow" },

        -- Routes (Rotas/Caminhos)
        routes = { glyph = "󰕘", hl = "MiniIconsCyan" },
        Routes = { glyph = "󰕘", hl = "MiniIconsCyan" },
        route = { glyph = "󰕘", hl = "MiniIconsCyan" },
        Route = { glyph = "󰕘", hl = "MiniIconsCyan" },

        -- Components (Peças de encaixe/Quebra-cabeça)
        components = { glyph = "󰩏", hl = "MiniIconsBlue" },
        Components = { glyph = "󰩏", hl = "MiniIconsBlue" },
        component = { glyph = "󰩏", hl = "MiniIconsBlue" },
        Component = { glyph = "󰩏", hl = "MiniIconsBlue" },

        -- Pages (Páginas/Documentos)
        pages = { glyph = "󰈙", hl = "MiniIconsGreen" },
        Pages = { glyph = "󰈙", hl = "MiniIconsGreen" },
        page = { glyph = "󰈙", hl = "MiniIconsGreen" },
        Page = { glyph = "󰈙", hl = "MiniIconsGreen" },

        -- Layouts (Estrutura visual/Monitor)
        layouts = { glyph = "󰘸", hl = "MiniIconsOrange" },
        Layouts = { glyph = "󰘸", hl = "MiniIconsOrange" },
        layout = { glyph = "󰘸", hl = "MiniIconsOrange" },
        Layout = { glyph = "󰘸", hl = "MiniIconsOrange" },

        -- Hooks (Ganchos)
        hooks = { glyph = "󰛢", hl = "MiniIconsPurple" },
        Hooks = { glyph = "󰛢", hl = "MiniIconsPurple" },
        hook = { glyph = "󰛢", hl = "MiniIconsPurple" },
        Hook = { glyph = "󰛢", hl = "MiniIconsPurple" },

        -- Store (Loja/Estado global)
        stores = { glyph = "󰆓", hl = "MiniIconsYellow" },
        Stores = { glyph = "󰆓", hl = "MiniIconsYellow" },
        store = { glyph = "󰆓", hl = "MiniIconsYellow" },
        Store = { glyph = "󰆓", hl = "MiniIconsYellow" },

        -- Context (Contexto/Livro aberto)
        contexts = { glyph = "󰆿", hl = "MiniIconsCyan" },
        Contexts = { glyph = "󰆿", hl = "MiniIconsCyan" },
        context = { glyph = "󰆿", hl = "MiniIconsCyan" },
        Context = { glyph = "󰆿", hl = "MiniIconsCyan" },

        -- Providers (Fornecedores/Plugs)
        providers = { glyph = "󰚌", hl = "MiniIconsPurple" },
        Providers = { glyph = "󰚌", hl = "MiniIconsPurple" },
        provider = { glyph = "󰚌", hl = "MiniIconsPurple" },
        Provider = { glyph = "󰚌", hl = "MiniIconsPurple" },

        -- ╔══════════════════════════════════════════╗
        -- ║              CLEAN ARCHITECTURE          ║
        -- ╚══════════════════════════════════════════╝

        -- Domain (Core/Alvo Central)
        domain = { glyph = "󰇽", hl = "MiniIconsPurple" },
        Domain = { glyph = "󰇽", hl = "MiniIconsPurple" },

        -- Application (Casos de uso/Maleta)
        application = { glyph = "󰟀", hl = "MiniIconsBlue" },
        Application = { glyph = "󰟀", hl = "MiniIconsBlue" },

        -- Infrastructure (Mundo externo/Rede de Servidores)
        infrastructure = { glyph = "󰒋", hl = "MiniIconsOrange" },
        Infrastructure = { glyph = "󰒋", hl = "MiniIconsOrange" },
        infra = { glyph = "󰒋", hl = "MiniIconsOrange" },
        Infra = { glyph = "󰒋", hl = "MiniIconsOrange" },

        -- Presentation
        presentation = { glyph = "󰊸", hl = "MiniIconsGreen" },
        Presentation = { glyph = "󰊸", hl = "MiniIconsGreen" },

        -- Interface Adapters (Adaptadores/Plugs)
        ["interface-adapters"] = { glyph = "󰚌", hl = "MiniIconsCyan" },
        ["Interface-Adapters"] = { glyph = "󰚌", hl = "MiniIconsCyan" },
        adapters = { glyph = "󰚌", hl = "MiniIconsCyan" },
        Adapters = { glyph = "󰚌", hl = "MiniIconsCyan" },
        adapter = { glyph = "󰚌", hl = "MiniIconsCyan" },
        Adapter = { glyph = "󰚌", hl = "MiniIconsCyan" },

        -- Enterprise Business Rules
        ["enterprise-business-rules"] = { glyph = "󰇽", hl = "MiniIconsPurple" },
        ["Enterprise-Business-Rules"] = { glyph = "󰇽", hl = "MiniIconsPurple" },

        -- Application Business Rules
        ["application-business-rules"] = { glyph = "󰟀", hl = "MiniIconsBlue" },
        ["Application-Business-Rules"] = { glyph = "󰟀", hl = "MiniIconsBlue" },

        -- Frameworks & Drivers
        ["frameworks-drivers"] = { glyph = "󰒋", hl = "MiniIconsOrange" },
        ["Frameworks-Drivers"] = { glyph = "󰒋", hl = "MiniIconsOrange" },

        -- ╔══════════════════════════════════════════╗
        -- ║           DOMAIN-DRIVEN DESIGN           ║
        -- ╚══════════════════════════════════════════╝

        -- Entities (Unidade singular)
        entities = { glyph = "󰆦", hl = "MiniIconsBlue" },
        Entities = { glyph = "󰆦", hl = "MiniIconsBlue" },
        entity = { glyph = "󰆦", hl = "MiniIconsBlue" },
        Entity = { glyph = "󰆦", hl = "MiniIconsBlue" },

        -- Value Objects (Imutáveis/Diamante)
        ["value-objects"] = { glyph = "󰛦", hl = "MiniIconsYellow" },
        ["Value-Objects"] = { glyph = "󰛦", hl = "MiniIconsYellow" },
        valueobjects = { glyph = "󰛦", hl = "MiniIconsYellow" },
        ValueObjects = { glyph = "󰛦", hl = "MiniIconsYellow" },
        valueobject = { glyph = "󰛦", hl = "MiniIconsYellow" },
        ValueObject = { glyph = "󰛦", hl = "MiniIconsYellow" },
        vo = { glyph = "󰛦", hl = "MiniIconsYellow" },
        VO = { glyph = "󰛦", hl = "MiniIconsYellow" },
        vos = { glyph = "󰛦", hl = "MiniIconsYellow" },
        VOs = { glyph = "󰛦", hl = "MiniIconsYellow" },

        -- Aggregates (Conjunto/Cubos)
        aggregates = { glyph = "󰆧", hl = "MiniIconsPurple" },
        Aggregates = { glyph = "󰆧", hl = "MiniIconsPurple" },
        aggregate = { glyph = "󰆧", hl = "MiniIconsPurple" },
        Aggregate = { glyph = "󰆧", hl = "MiniIconsPurple" },
        ["aggregate-roots"] = { glyph = "󰆧", hl = "MiniIconsPurple" },
        ["Aggregate-Roots"] = { glyph = "󰆧", hl = "MiniIconsPurple" },
        ["aggregate_root"] = { glyph = "󰆧", hl = "MiniIconsPurple" },
        ["Aggregate_Root"] = { glyph = "󰆧", hl = "MiniIconsPurple" },

        -- Repositories (Armazenamento/Caixa)
        repositories = { glyph = "󰆯", hl = "MiniIconsOrange" },
        Repositories = { glyph = "󰆯", hl = "MiniIconsOrange" },
        repository = { glyph = "󰆯", hl = "MiniIconsOrange" },
        Repository = { glyph = "󰆯", hl = "MiniIconsOrange" },
        repos = { glyph = "󰆯", hl = "MiniIconsOrange" },
        Repos = { glyph = "󰆯", hl = "MiniIconsOrange" },
        repo = { glyph = "󰆯", hl = "MiniIconsOrange" },
        Repo = { glyph = "󰆯", hl = "MiniIconsOrange" },

        -- Domain Services
        ["domain-services"] = { glyph = "󰢏", hl = "MiniIconsPurple" },
        ["Domain-Services"] = { glyph = "󰢏", hl = "MiniIconsPurple" },
        domainservices = { glyph = "󰢏", hl = "MiniIconsPurple" },
        DomainServices = { glyph = "󰢏", hl = "MiniIconsPurple" },

        -- Application Services
        ["application-services"] = { glyph = "󰢏", hl = "MiniIconsBlue" },
        ["Application-Services"] = { glyph = "󰢏", hl = "MiniIconsBlue" },
        applicationservices = { glyph = "󰢏", hl = "MiniIconsBlue" },
        ApplicationServices = { glyph = "󰢏", hl = "MiniIconsBlue" },

        -- Factories (Fábricas)
        factories = { glyph = "󰃬", hl = "MiniIconsGreen" },
        Factories = { glyph = "󰃬", hl = "MiniIconsGreen" },
        factory = { glyph = "󰃬", hl = "MiniIconsGreen" },
        Factory = { glyph = "󰃬", hl = "MiniIconsGreen" },

        -- Domain Events (Eventos/Relâmpago)
        events = { glyph = "󱐋", hl = "MiniIconsYellow" },
        Events = { glyph = "󱐋", hl = "MiniIconsYellow" },
        event = { glyph = "󱐋", hl = "MiniIconsYellow" },
        Event = { glyph = "󱐋", hl = "MiniIconsYellow" },
        ["domain-events"] = { glyph = "󱐋", hl = "MiniIconsYellow" },
        ["Domain-Events"] = { glyph = "󱐋", hl = "MiniIconsYellow" },
        domainevents = { glyph = "󱐋", hl = "MiniIconsYellow" },
        DomainEvents = { glyph = "󱐋", hl = "MiniIconsYellow" },

        -- Commands (Terminal/Comando)
        commands = { glyph = "󰘳", hl = "MiniIconsGreen" },
        Commands = { glyph = "󰘳", hl = "MiniIconsGreen" },
        command = { glyph = "󰘳", hl = "MiniIconsGreen" },
        Command = { glyph = "󰘳", hl = "MiniIconsGreen" },

        -- Queries (Pesquisa)
        queries = { glyph = "󰍉", hl = "MiniIconsCyan" },
        Queries = { glyph = "󰍉", hl = "MiniIconsCyan" },
        query = { glyph = "󰍉", hl = "MiniIconsCyan" },
        Query = { glyph = "󰍉", hl = "MiniIconsCyan" },

        -- Handlers (Lidadores/Engrenagens)
        handlers = { glyph = "󰢏", hl = "MiniIconsPurple" },
        Handlers = { glyph = "󰢏", hl = "MiniIconsPurple" },
        handler = { glyph = "󰢏", hl = "MiniIconsPurple" },
        Handler = { glyph = "󰢏", hl = "MiniIconsPurple" },
        ["command-handlers"] = { glyph = "󰢏", hl = "MiniIconsGreen" },
        ["Command-Handlers"] = { glyph = "󰢏", hl = "MiniIconsGreen" },
        ["query-handlers"] = { glyph = "󰢏", hl = "MiniIconsCyan" },
        ["Query-Handlers"] = { glyph = "󰢏", hl = "MiniIconsCyan" },
        ["event-handlers"] = { glyph = "󰢏", hl = "MiniIconsYellow" },
        ["Event-Handlers"] = { glyph = "󰢏", hl = "MiniIconsYellow" },

        -- Ports (Portas de entrada/Tomadas)
        ports = { glyph = "󰚌", hl = "MiniIconsCyan" },
        Ports = { glyph = "󰚌", hl = "MiniIconsCyan" },
        port = { glyph = "󰚌", hl = "MiniIconsCyan" },
        Port = { glyph = "󰚌", hl = "MiniIconsCyan" },

        -- Use Cases (Casos de uso/Maleta)["use-cases"] = { glyph = "󰟀", hl = "MiniIconsBlue" },["Use-Cases"] = { glyph = "󰟀", hl = "MiniIconsBlue" },
        usecases = { glyph = "󰟀", hl = "MiniIconsBlue" },
        UseCases = { glyph = "󰟀", hl = "MiniIconsBlue" },
        usecase = { glyph = "󰟀", hl = "MiniIconsBlue" },
        UseCase = { glyph = "󰟀", hl = "MiniIconsBlue" },

        -- Gateways (API)
        gateways = { glyph = "󰴚", hl = "MiniIconsOrange" },
        Gateways = { glyph = "󰴚", hl = "MiniIconsOrange" },
        gateway = { glyph = "󰴚", hl = "MiniIconsOrange" },
        Gateway = { glyph = "󰴚", hl = "MiniIconsOrange" },

        -- DTOs (Transferência de Dados/Troca)
        dtos = { glyph = "󰯍", hl = "MiniIconsYellow" },
        DTOs = { glyph = "󰯍", hl = "MiniIconsYellow" },
        dto = { glyph = "󰯍", hl = "MiniIconsYellow" },
        DTO = { glyph = "󰯍", hl = "MiniIconsYellow" },

        -- Exceptions (Erros/Alertas)
        exceptions = { glyph = "󰅚", hl = "MiniIconsRed" },
        Exceptions = { glyph = "󰅚", hl = "MiniIconsRed" },
        exception = { glyph = "󰅚", hl = "MiniIconsRed" },
        Exception = { glyph = "󰅚", hl = "MiniIconsRed" },

        -- Contracts / Interfaces (Apertos de mão/Contratos)
        contracts = { glyph = "󰨡", hl = "MiniIconsCyan" },
        Contracts = { glyph = "󰨡", hl = "MiniIconsCyan" },
        contract = { glyph = "󰨡", hl = "MiniIconsCyan" },
        Contract = { glyph = "󰨡", hl = "MiniIconsCyan" },
        interfaces = { glyph = "󰨡", hl = "MiniIconsCyan" },
        Interfaces = { glyph = "󰨡", hl = "MiniIconsCyan" },
        interface = { glyph = "󰨡", hl = "MiniIconsCyan" },
        Interface = { glyph = "󰨡", hl = "MiniIconsCyan" },

        -- Specifications (Validações/Checklist)
        specifications = { glyph = "󰡰", hl = "MiniIconsYellow" },
        Specifications = { glyph = "󰡰", hl = "MiniIconsYellow" },
        specification = { glyph = "󰡰", hl = "MiniIconsYellow" },
        Specification = { glyph = "󰡰", hl = "MiniIconsYellow" },
        specs = { glyph = "󰡰", hl = "MiniIconsYellow" },
        Specs = { glyph = "󰡰", hl = "MiniIconsYellow" },
        spec = { glyph = "󰡰", hl = "MiniIconsYellow" },
        Spec = { glyph = "󰡰", hl = "MiniIconsYellow" },

        -- Policies / Guards (Escudo)
        policies = { glyph = "󰾆", hl = "MiniIconsRed" },
        Policies = { glyph = "󰾆", hl = "MiniIconsRed" },
        policy = { glyph = "󰾆", hl = "MiniIconsRed" },
        Policy = { glyph = "󰾆", hl = "MiniIconsRed" },
        guards = { glyph = "󰾆", hl = "MiniIconsRed" },
        Guards = { glyph = "󰾆", hl = "MiniIconsRed" },
        guard = { glyph = "󰾆", hl = "MiniIconsRed" },
        Guard = { glyph = "󰾆", hl = "MiniIconsRed" },

        -- Serializers (Chaves Json/Código)
        serializers = { glyph = "󰘧", hl = "MiniIconsYellow" },
        Serializers = { glyph = "󰘧", hl = "MiniIconsYellow" },
        serializer = { glyph = "󰘧", hl = "MiniIconsYellow" },
        Serializer = { glyph = "󰘧", hl = "MiniIconsYellow" },

        -- Decorators (Varinha mágica)
        decorators = { glyph = "󰐘", hl = "MiniIconsPurple" },
        Decorators = { glyph = "󰐘", hl = "MiniIconsPurple" },
        decorator = { glyph = "󰐘", hl = "MiniIconsPurple" },
        Decorator = { glyph = "󰐘", hl = "MiniIconsPurple" },

        -- Pipes (Cano/Fluxo)
        pipes = { glyph = "󰘦", hl = "MiniIconsCyan" },
        Pipes = { glyph = "󰘦", hl = "MiniIconsCyan" },
        pipe = { glyph = "󰘦", hl = "MiniIconsCyan" },
        Pipe = { glyph = "󰘦", hl = "MiniIconsCyan" },

        -- Filters (Filtros)
        filters = { glyph = "󰘨", hl = "MiniIconsYellow" },
        Filters = { glyph = "󰘨", hl = "MiniIconsYellow" },
        filter = { glyph = "󰘨", hl = "MiniIconsYellow" },
        Filter = { glyph = "󰘨", hl = "MiniIconsYellow" },

        -- Strategies (Estratégia/Cavalo de xadrez)
        strategies = { glyph = "󰕓", hl = "MiniIconsPurple" },
        Strategies = { glyph = "󰕓", hl = "MiniIconsPurple" },
        strategy = { glyph = "󰕓", hl = "MiniIconsPurple" },
        Strategy = { glyph = "󰕓", hl = "MiniIconsPurple" },

        -- Mappers (Transformações/Troca)
        mappers = { glyph = "󰯍", hl = "MiniIconsYellow" },
        Mappers = { glyph = "󰯍", hl = "MiniIconsYellow" },
        mapper = { glyph = "󰯍", hl = "MiniIconsYellow" },
        Mapper = { glyph = "󰯍", hl = "MiniIconsYellow" },

        -- Validators (Checklist)
        validators = { glyph = "󰡰", hl = "MiniIconsGreen" },
        Validators = { glyph = "󰡰", hl = "MiniIconsGreen" },
        validator = { glyph = "󰡰", hl = "MiniIconsGreen" },
        Validator = { glyph = "󰡰", hl = "MiniIconsGreen" },

        -- Interceptors (Interceptação/Caminho)
        interceptors = { glyph = "󰕘", hl = "MiniIconsYellow" },
        Interceptors = { glyph = "󰕘", hl = "MiniIconsYellow" },
        interceptor = { glyph = "󰕘", hl = "MiniIconsYellow" },
        Interceptor = { glyph = "󰕘", hl = "MiniIconsYellow" },

        -- Sagas (Fluxo de transações complexo/Ciclo)
        sagas = { glyph = "󰑐", hl = "MiniIconsOrange" },
        Sagas = { glyph = "󰑐", hl = "MiniIconsOrange" },
        saga = { glyph = "󰑐", hl = "MiniIconsOrange" },
        Saga = { glyph = "󰑐", hl = "MiniIconsOrange" },

        -- Projections (Visualização externa)
        projections = { glyph = "󰈈", hl = "MiniIconsGreen" },
        Projections = { glyph = "󰈈", hl = "MiniIconsGreen" },
        projection = { glyph = "󰈈", hl = "MiniIconsGreen" },
        Projection = { glyph = "󰈈", hl = "MiniIconsGreen" },

        -- Read/Write Models (CQRS)
        ["read-models"] = { glyph = "󰈈", hl = "MiniIconsGreen" }, -- Olho/Leitura
        ["Read-Models"] = { glyph = "󰈈", hl = "MiniIconsGreen" },
        readmodels = { glyph = "󰈈", hl = "MiniIconsGreen" },
        ReadModels = { glyph = "󰈈", hl = "MiniIconsGreen" },
        ["write-models"] = { glyph = "󰏫", hl = "MiniIconsBlue" }, -- Caneta/Escrita
        ["Write-Models"] = { glyph = "󰏫", hl = "MiniIconsBlue" },
        writemodels = { glyph = "󰏫", hl = "MiniIconsBlue" },
        WriteModels = { glyph = "󰏫", hl = "MiniIconsBlue" },

        -- Bounded Contexts
        ["bounded-contexts"] = { glyph = "󰆿", hl = "MiniIconsCyan" },
        ["Bounded-Contexts"] = { glyph = "󰆿", hl = "MiniIconsCyan" },

        -- Anti-Corruption Layer
        acl = { glyph = "󰾆", hl = "MiniIconsRed" },
        ACL = { glyph = "󰾆", hl = "MiniIconsRed" },
        ["anti-corruption-layer"] = { glyph = "󰾆", hl = "MiniIconsRed" },
        ["Anti-Corruption-Layer"] = { glyph = "󰾆", hl = "MiniIconsRed" },

        -- Shared Kernel (Núcleo Compartilhado/Link)
        ["shared-kernel"] = { glyph = "󰧜", hl = "MiniIconsCyan" },
        ["Shared-Kernel"] = { glyph = "󰧜", hl = "MiniIconsCyan" },
        sharedkernel = { glyph = "󰧜", hl = "MiniIconsCyan" },
        SharedKernel = { glyph = "󰧜", hl = "MiniIconsCyan" },

        -- ╔══════════════════════════════════════════╗
        -- ║              API / REST / GRAPHQL         ║
        -- ╚══════════════════════════════════════════╝

        -- API
        api = { glyph = "󰴚", hl = "MiniIconsCyan" },
        API = { glyph = "󰴚", hl = "MiniIconsCyan" },
        apis = { glyph = "󰴚", hl = "MiniIconsCyan" },
        APIs = { glyph = "󰴚", hl = "MiniIconsCyan" },

        -- Endpoints
        endpoints = { glyph = "󰴚", hl = "MiniIconsCyan" },
        Endpoints = { glyph = "󰴚", hl = "MiniIconsCyan" },
        endpoint = { glyph = "󰴚", hl = "MiniIconsCyan" },
        Endpoint = { glyph = "󰴚", hl = "MiniIconsCyan" },

        -- Versioned API
        v1 = { glyph = "󰴚", hl = "MiniIconsCyan" },
        V1 = { glyph = "󰴚", hl = "MiniIconsCyan" },
        v2 = { glyph = "󰴚", hl = "MiniIconsCyan" },
        V2 = { glyph = "󰴚", hl = "MiniIconsCyan" },
        v3 = { glyph = "󰴚", hl = "MiniIconsCyan" },
        V3 = { glyph = "󰴚", hl = "MiniIconsCyan" },

        -- Resources (Recursos Web)
        resources = { glyph = "󰉏", hl = "MiniIconsOrange" },
        Resources = { glyph = "󰉏", hl = "MiniIconsOrange" },
        resource = { glyph = "󰉏", hl = "MiniIconsOrange" },
        Resource = { glyph = "󰉏", hl = "MiniIconsOrange" },

        -- Requests / Responses
        requests = { glyph = "󰇚", hl = "MiniIconsGreen" }, -- Seta Entrando
        Requests = { glyph = "󰇚", hl = "MiniIconsGreen" },
        request = { glyph = "󰇚", hl = "MiniIconsGreen" },
        Request = { glyph = "󰇚", hl = "MiniIconsGreen" },
        responses = { glyph = "󰕗", hl = "MiniIconsBlue" }, -- Seta Saindo
        Responses = { glyph = "󰕗", hl = "MiniIconsBlue" },
        response = { glyph = "󰕗", hl = "MiniIconsBlue" },
        Response = { glyph = "󰕗", hl = "MiniIconsBlue" },

        -- Resolvers (GraphQL)
        resolvers = { glyph = "󰢏", hl = "MiniIconsPink" },
        Resolvers = { glyph = "󰢏", hl = "MiniIconsPink" },
        resolver = { glyph = "󰢏", hl = "MiniIconsPink" },
        Resolver = { glyph = "󰢏", hl = "MiniIconsPink" },

        -- Schemas
        schemas = { glyph = "󰘧", hl = "MiniIconsCyan" },
        Schemas = { glyph = "󰘧", hl = "MiniIconsCyan" },
        schema = { glyph = "󰘧", hl = "MiniIconsCyan" },
        Schema = { glyph = "󰘧", hl = "MiniIconsCyan" },
        graphql = { glyph = "󰡷", hl = "MiniIconsPink" },
        GraphQL = { glyph = "󰡷", hl = "MiniIconsPink" },

        -- Types
        types = { glyph = "󰜢", hl = "MiniIconsYellow" },
        Types = { glyph = "󰜢", hl = "MiniIconsYellow" },
        type = { glyph = "󰜢", hl = "MiniIconsYellow" },
        Type = { glyph = "󰜢", hl = "MiniIconsYellow" },

        -- Auth & Permissions (Escudo/Verificado)
        auth = { glyph = "󰟵", hl = "MiniIconsRed" },
        Auth = { glyph = "󰟵", hl = "MiniIconsRed" },
        authentication = { glyph = "󰟵", hl = "MiniIconsRed" },
        Authentication = { glyph = "󰟵", hl = "MiniIconsRed" },
        authorization = { glyph = "󰟵", hl = "MiniIconsRed" },
        Authorization = { glyph = "󰟵", hl = "MiniIconsRed" },
        permissions = { glyph = "󰟵", hl = "MiniIconsRed" },
        Permissions = { glyph = "󰟵", hl = "MiniIconsRed" },
        permission = { glyph = "󰟵", hl = "MiniIconsRed" },
        Permission = { glyph = "󰟵", hl = "MiniIconsRed" },
        roles = { glyph = "󰟵", hl = "MiniIconsRed" },
        Roles = { glyph = "󰟵", hl = "MiniIconsRed" },
        role = { glyph = "󰟵", hl = "MiniIconsRed" },
        Role = { glyph = "󰟵", hl = "MiniIconsRed" },

        -- ╔══════════════════════════════════════════╗
        -- ║          CONFIG / BUILD / META            ║
        -- ╚══════════════════════════════════════════╝

        -- Config
        configs = { glyph = "󰒓", hl = "MiniIconsOrange" },
        Configs = { glyph = "󰒓", hl = "MiniIconsOrange" },
        config = { glyph = "󰒓", hl = "MiniIconsOrange" },
        Config = { glyph = "󰒓", hl = "MiniIconsOrange" },
        configuration = { glyph = "󰒓", hl = "MiniIconsOrange" },
        Configuration = { glyph = "󰒓", hl = "MiniIconsOrange" },
        settings = { glyph = "󰒓", hl = "MiniIconsOrange" },
        Settings = { glyph = "󰒓", hl = "MiniIconsOrange" },

        -- Env (Ajustes/Sliders)
        envs = { glyph = "󰭂", hl = "MiniIconsYellow" },
        Envs = { glyph = "󰭂", hl = "MiniIconsYellow" },
        env = { glyph = "󰭂", hl = "MiniIconsYellow" },
        Env = { glyph = "󰭂", hl = "MiniIconsYellow" },

        -- Tests
        tests = { glyph = "󰙨", hl = "MiniIconsRed" },
        Tests = { glyph = "󰙨", hl = "MiniIconsRed" },
        test = { glyph = "󰙨", hl = "MiniIconsRed" },
        Test = { glyph = "󰙨", hl = "MiniIconsRed" },
        ["__tests__"] = { glyph = "󰙨", hl = "MiniIconsRed" },
        e2e = { glyph = "󰙨", hl = "MiniIconsRed" },
        E2E = { glyph = "󰙨", hl = "MiniIconsRed" },

        -- Utils (Ferramentas)
        utils = { glyph = "󰦌", hl = "MiniIconsCyan" },
        Utils = { glyph = "󰦌", hl = "MiniIconsCyan" },
        util = { glyph = "󰦌", hl = "MiniIconsCyan" },
        Util = { glyph = "󰦌", hl = "MiniIconsCyan" },
        helpers = { glyph = "󰦌", hl = "MiniIconsCyan" },
        Helpers = { glyph = "󰦌", hl = "MiniIconsCyan" },
        helper = { glyph = "󰦌", hl = "MiniIconsCyan" },
        Helper = { glyph = "󰦌", hl = "MiniIconsCyan" },

        -- Lib (Pacotes)
        libs = { glyph = "󰏗", hl = "MiniIconsGreen" },
        Libs = { glyph = "󰏗", hl = "MiniIconsGreen" },
        lib = { glyph = "󰏗", hl = "MiniIconsGreen" },
        Lib = { glyph = "󰏗", hl = "MiniIconsGreen" },

        -- Shared
        shared = { glyph = "󰧜", hl = "MiniIconsCyan" },
        Shared = { glyph = "󰧜", hl = "MiniIconsCyan" },
        common = { glyph = "󰧜", hl = "MiniIconsCyan" },
        Common = { glyph = "󰧜", hl = "MiniIconsCyan" },
        core = { glyph = "󰇽", hl = "MiniIconsPurple" },
        Core = { glyph = "󰇽", hl = "MiniIconsPurple" },

        -- Public / Static (Web/Navegador)
        public = { glyph = "󰇄", hl = "MiniIconsOrange" },
        Public = { glyph = "󰇄", hl = "MiniIconsOrange" },
        static = { glyph = "󰇄", hl = "MiniIconsOrange" },
        Static = { glyph = "󰇄", hl = "MiniIconsOrange" },

        -- Assets
        assets = { glyph = "󰉏", hl = "MiniIconsOrange" },
        Assets = { glyph = "󰉏", hl = "MiniIconsOrange" },
        asset = { glyph = "󰉏", hl = "MiniIconsOrange" },
        Asset = { glyph = "󰉏", hl = "MiniIconsOrange" },

        -- Images
        images = { glyph = "󰋫", hl = "MiniIconsGreen" },
        Images = { glyph = "󰋫", hl = "MiniIconsGreen" },
        img = { glyph = "󰋫", hl = "MiniIconsGreen" },
        Img = { glyph = "󰋫", hl = "MiniIconsGreen" },
        image = { glyph = "󰋫", hl = "MiniIconsGreen" },
        Image = { glyph = "󰋫", hl = "MiniIconsGreen" },

        -- Icons (Paleta)
        icons = { glyph = "󰋩", hl = "MiniIconsPurple" },
        Icons = { glyph = "󰋩", hl = "MiniIconsPurple" },
        icon = { glyph = "󰋩", hl = "MiniIconsPurple" },
        Icon = { glyph = "󰋩", hl = "MiniIconsPurple" },

        -- Fonts
        fonts = { glyph = "󰛖", hl = "MiniIconsGrey" },
        Fonts = { glyph = "󰛖", hl = "MiniIconsGrey" },

        -- Styles
        styles = { glyph = "󰟖", hl = "MiniIconsPink" },
        Styles = { glyph = "󰟖", hl = "MiniIconsPink" },
        style = { glyph = "󰟖", hl = "MiniIconsPink" },
        Style = { glyph = "󰟖", hl = "MiniIconsPink" },
        css = { glyph = "󰟖", hl = "MiniIconsBlue" },
        CSS = { glyph = "󰟖", hl = "MiniIconsBlue" },
        scss = { glyph = "󰟖", hl = "MiniIconsPink" },
        SCSS = { glyph = "󰟖", hl = "MiniIconsPink" },

        -- Src (Tags de código)
        src = { hl = "MiniIconsRed" },
        Src = { hl = "MiniIconsRed" },
        source = { hl = "MiniIconsRed" },
        Source = { hl = "MiniIconsRed" },
        app = { hl = "MiniIconsRed" },
        App = { hl = "MiniIconsRed" },

        -- Database
        databases = { glyph = "󰆼", hl = "MiniIconsOrange" },
        Databases = { glyph = "󰆼", hl = "MiniIconsOrange" },
        database = { glyph = "󰆼", hl = "MiniIconsOrange" },
        Database = { glyph = "󰆼", hl = "MiniIconsOrange" },
        db = { glyph = "󰆼", hl = "MiniIconsOrange" },
        DB = { glyph = "󰆼", hl = "MiniIconsOrange" },

        -- Migrations (Histórico de mudanças/Sincronização)
        migrations = { glyph = "󰑐", hl = "MiniIconsYellow" },
        Migrations = { glyph = "󰑐", hl = "MiniIconsYellow" },
        migration = { glyph = "󰑐", hl = "MiniIconsYellow" },
        Migration = { glyph = "󰑐", hl = "MiniIconsYellow" },

        -- Seeds (Planta/Semente)
        seeds = { glyph = "󰆖", hl = "MiniIconsGreen" },
        Seeds = { glyph = "󰆖", hl = "MiniIconsGreen" },
        seed = { glyph = "󰆖", hl = "MiniIconsGreen" },
        Seed = { glyph = "󰆖", hl = "MiniIconsGreen" },

        -- Docs
        docs = { glyph = "󰈙", hl = "MiniIconsGrey" },
        Docs = { glyph = "󰈙", hl = "MiniIconsGrey" },
        doc = { glyph = "󰈙", hl = "MiniIconsGrey" },
        Doc = { glyph = "󰈙", hl = "MiniIconsGrey" },
        documentation = { glyph = "󰈙", hl = "MiniIconsGrey" },
        Documentation = { glyph = "󰈙", hl = "MiniIconsGrey" },

        -- Git
        [".git"] = { glyph = "󰊢", hl = "MiniIconsOrange" },
        [".github"] = { glyph = "󰊤", hl = "MiniIconsGrey" },
        [".gitlab"] = { glyph = "󰮠", hl = "MiniIconsOrange" },

        -- Node
        node_modules = { glyph = "󰎙", hl = "MiniIconsGreen" },

        -- Docker
        docker = { glyph = "󰡨", hl = "MiniIconsBlue" },
        Docker = { glyph = "󰡨", hl = "MiniIconsBlue" },
        [".docker"] = { glyph = "󰡨", hl = "MiniIconsBlue" },

        -- Terraform
        terraform = { glyph = "󰵈", hl = "MiniIconsPurple" },
        Terraform = { glyph = "󰵈", hl = "MiniIconsPurple" },
        modules = { glyph = "󰕔", hl = "MiniIconsPurple" },
        Modules = { glyph = "󰕔", hl = "MiniIconsPurple" },

        -- Locales / i18n
        locales = { glyph = "󰗊", hl = "MiniIconsCyan" },
        Locales = { glyph = "󰗊", hl = "MiniIconsCyan" },
        locale = { glyph = "󰗊", hl = "MiniIconsCyan" },
        Locale = { glyph = "󰗊", hl = "MiniIconsCyan" },
        i18n = { glyph = "󰗊", hl = "MiniIconsCyan" },
        I18N = { glyph = "󰗊", hl = "MiniIconsCyan" },
        lang = { glyph = "󰗊", hl = "MiniIconsCyan" },
        Lang = { glyph = "󰗊", hl = "MiniIconsCyan" },
        languages = { glyph = "󰗊", hl = "MiniIconsCyan" },
        Languages = { glyph = "󰗊", hl = "MiniIconsCyan" },
        translations = { glyph = "󰗊", hl = "MiniIconsCyan" },
        Translations = { glyph = "󰗊", hl = "MiniIconsCyan" },

        -- Scripts
        scripts = { glyph = "󰆍", hl = "MiniIconsGreen" },
        Scripts = { glyph = "󰆍", hl = "MiniIconsGreen" },
        bin = { glyph = "󰆍", hl = "MiniIconsGreen" },
        Bin = { glyph = "󰆍", hl = "MiniIconsGreen" },

        -- Plugins
        plugins = { glyph = "󰏗", hl = "MiniIconsPurple" },
        Plugins = { glyph = "󰏗", hl = "MiniIconsPurple" },
        plugin = { glyph = "󰏗", hl = "MiniIconsPurple" },
        Plugin = { glyph = "󰏗", hl = "MiniIconsPurple" },
        extensions = { glyph = "󰏗", hl = "MiniIconsPurple" },
        Extensions = { glyph = "󰏗", hl = "MiniIconsPurple" },

        -- Temp / Cache (Lixeira/Descartáveis)
        temp = { glyph = "󰆐", hl = "MiniIconsGrey" },
        Temp = { glyph = "󰆐", hl = "MiniIconsGrey" },
        cache = { glyph = "󰆐", hl = "MiniIconsGrey" },
        Cache = { glyph = "󰆐", hl = "MiniIconsGrey" },

        -- Build / Dist (Ferramenta de construção)
        dist = { glyph = "󰦢", hl = "MiniIconsGreen" },
        Dist = { glyph = "󰦢", hl = "MiniIconsGreen" },
        build = { glyph = "󰦢", hl = "MiniIconsGreen" },
        Build = { glyph = "󰦢", hl = "MiniIconsGreen" },
        builds = { glyph = "󰦢", hl = "MiniIconsGreen" },
        Builds = { glyph = "󰦢", hl = "MiniIconsGreen" },
        out = { glyph = "󰦢", hl = "MiniIconsGreen" },
        Out = { glyph = "󰦢", hl = "MiniIconsGreen" },
        output = { glyph = "󰦢", hl = "MiniIconsGreen" },
        Output = { glyph = "󰦢", hl = "MiniIconsGreen" },

        -- Backup
        backups = { glyph = "󰁯", hl = "MiniIconsGrey" },
        Backups = { glyph = "󰁯", hl = "MiniIconsGrey" },
        backup = { glyph = "󰁯", hl = "MiniIconsGrey" },
        Backup = { glyph = "󰁯", hl = "MiniIconsGrey" },

        -- Logs
        logs = { glyph = "󰌱", hl = "MiniIconsGrey" },
        Logs = { glyph = "󰌱", hl = "MiniIconsGrey" },
        log = { glyph = "󰌱", hl = "MiniIconsGrey" },
        Log = { glyph = "󰌱", hl = "MiniIconsGrey" },

        -- Fixtures
        fixtures = { glyph = "󰉐", hl = "MiniIconsYellow" },
        Fixtures = { glyph = "󰉐", hl = "MiniIconsYellow" },
        fixture = { glyph = "󰉐", hl = "MiniIconsYellow" },
        Fixture = { glyph = "󰉐", hl = "MiniIconsYellow" },

        -- Data
        data = { glyph = "󰆼", hl = "MiniIconsYellow" },
        Data = { glyph = "󰆼", hl = "MiniIconsYellow" },

        -- Packages
        packages = { glyph = "󰏗", hl = "MiniIconsPurple" },
        Packages = { glyph = "󰏗", hl = "MiniIconsPurple" },
        package = { glyph = "󰏗", hl = "MiniIconsPurple" },
        Package = { glyph = "󰏗", hl = "MiniIconsPurple" },

        -- Errors
        errors = { glyph = "󰅚", hl = "MiniIconsRed" },
        Errors = { glyph = "󰅚", hl = "MiniIconsRed" },
        error = { glyph = "󰅚", hl = "MiniIconsRed" },
        Error = { glyph = "󰅚", hl = "MiniIconsRed" },

        -- Warnings
        warnings = { glyph = "󰀪", hl = "MiniIconsYellow" },
        Warnings = { glyph = "󰀪", hl = "MiniIconsYellow" },
        warning = { glyph = "󰀪", hl = "MiniIconsYellow" },
        Warning = { glyph = "󰀪", hl = "MiniIconsYellow" },

        -- Notifications
        notifications = { glyph = "󰂚", hl = "MiniIconsYellow" },
        Notifications = { glyph = "󰂚", hl = "MiniIconsYellow" },
        notification = { glyph = "󰂚", hl = "MiniIconsYellow" },
        Notification = { glyph = "󰂚", hl = "MiniIconsYellow" },

        -- Jobs / Tasks / Queues (Checklist)
        jobs = { glyph = "󰡰", hl = "MiniIconsGreen" },
        Jobs = { glyph = "󰡰", hl = "MiniIconsGreen" },
        job = { glyph = "󰡰", hl = "MiniIconsGreen" },
        Job = { glyph = "󰡰", hl = "MiniIconsGreen" },
        tasks = { glyph = "󰡰", hl = "MiniIconsGreen" },
        Tasks = { glyph = "󰡰", hl = "MiniIconsGreen" },
        task = { glyph = "󰡰", hl = "MiniIconsGreen" },
        Task = { glyph = "󰡰", hl = "MiniIconsGreen" },
        queue = { glyph = "󰡰", hl = "MiniIconsGreen" },
        Queue = { glyph = "󰡰", hl = "MiniIconsGreen" },
        queues = { glyph = "󰡰", hl = "MiniIconsGreen" },
        Queues = { glyph = "󰡰", hl = "MiniIconsGreen" },

        -- Cron
        cron = { glyph = "󰥔", hl = "MiniIconsOrange" },
        Cron = { glyph = "󰥔", hl = "MiniIconsOrange" },
        crons = { glyph = "󰥔", hl = "MiniIconsOrange" },
        Crons = { glyph = "󰥔", hl = "MiniIconsOrange" },
        scheduled = { glyph = "󰥔", hl = "MiniIconsOrange" },
        Scheduled = { glyph = "󰥔", hl = "MiniIconsOrange" },

        -- ╔══════════════════════════════════════════╗
        -- ║              SECURITY                    ║
        -- ╚══════════════════════════════════════════╝

        -- Security
        security = { glyph = "󰌾", hl = "MiniIconsRed" },
        Security = { glyph = "󰌾", hl = "MiniIconsRed" },

        -- Secrets
        secrets = { glyph = "󰌾", hl = "MiniIconsRed" },
        Secrets = { glyph = "󰌾", hl = "MiniIconsRed" },
        secret = { glyph = "󰌾", hl = "MiniIconsRed" },
        Secret = { glyph = "󰌾", hl = "MiniIconsRed" },

        -- Encryption
        encryption = { glyph = "󰌾", hl = "MiniIconsRed" },
        Encryption = { glyph = "󰌾", hl = "MiniIconsRed" },
        encrypt = { glyph = "󰌾", hl = "MiniIconsRed" },
        Encrypt = { glyph = "󰌾", hl = "MiniIconsRed" },
        decrypt = { glyph = "󰌾", hl = "MiniIconsRed" },
        Decrypt = { glyph = "󰌾", hl = "MiniIconsRed" },

        -- Certificates
        certificates = { glyph = "󰄤", hl = "MiniIconsYellow" },
        Certificates = { glyph = "󰄤", hl = "MiniIconsYellow" },
        certificate = { glyph = "󰄤", hl = "MiniIconsYellow" },
        Certificate = { glyph = "󰄤", hl = "MiniIconsYellow" },
        certs = { glyph = "󰄤", hl = "MiniIconsYellow" },
        Certs = { glyph = "󰄤", hl = "MiniIconsYellow" },
        cert = { glyph = "󰄤", hl = "MiniIconsYellow" },
        Cert = { glyph = "󰄤", hl = "MiniIconsYellow" },

        -- Tokens / Keys
        tokens = { glyph = "󰌋", hl = "MiniIconsOrange" },
        Tokens = { glyph = "󰌋", hl = "MiniIconsOrange" },
        token = { glyph = "󰌋", hl = "MiniIconsOrange" },
        Token = { glyph = "󰌋", hl = "MiniIconsOrange" },
        keys = { glyph = "󰌋", hl = "MiniIconsYellow" },
        Keys = { glyph = "󰌋", hl = "MiniIconsYellow" },
        key = { glyph = "󰌋", hl = "MiniIconsYellow" },
        Key = { glyph = "󰌋", hl = "MiniIconsYellow" },
        ["api-keys"] = { glyph = "󰌋", hl = "MiniIconsYellow" },
        ["Api-Keys"] = { glyph = "󰌋", hl = "MiniIconsYellow" },
        apikeys = { glyph = "󰌋", hl = "MiniIconsYellow" },
        ApiKeys = { glyph = "󰌋", hl = "MiniIconsYellow" },

        -- JWT
        jwt = { glyph = "󰌋", hl = "MiniIconsOrange" },
        JWT = { glyph = "󰌋", hl = "MiniIconsOrange" },

        -- OAuth
        oauth = { glyph = "󰌋", hl = "MiniIconsRed" },
        OAuth = { glyph = "󰌋", hl = "MiniIconsRed" },
        ["oauth2"] = { glyph = "󰌋", hl = "MiniIconsRed" },
        OAuth2 = { glyph = "󰌋", hl = "MiniIconsRed" },

        -- Session
        sessions = { glyph = "󰹯", hl = "MiniIconsYellow" },
        Sessions = { glyph = "󰹯", hl = "MiniIconsYellow" },
        session = { glyph = "󰹯", hl = "MiniIconsYellow" },
        Session = { glyph = "󰹯", hl = "MiniIconsYellow" },

        -- CORS / SSL / TLS / Firewall (Verificação de segurança)
        cors = { glyph = "󰟵", hl = "MiniIconsOrange" },
        CORS = { glyph = "󰟵", hl = "MiniIconsOrange" },
        ssl = { glyph = "󰟵", hl = "MiniIconsGreen" },
        SSL = { glyph = "󰟵", hl = "MiniIconsGreen" },
        tls = { glyph = "󰟵", hl = "MiniIconsGreen" },
        TLS = { glyph = "󰟵", hl = "MiniIconsGreen" },
        firewall = { glyph = "󰟵", hl = "MiniIconsRed" },
        Firewall = { glyph = "󰟵", hl = "MiniIconsRed" },

        -- Whitelist / Blacklist
        whitelist = { glyph = "󰄬", hl = "MiniIconsGreen" },
        Whitelist = { glyph = "󰄬", hl = "MiniIconsGreen" },
        blacklist = { glyph = "󰅚", hl = "MiniIconsRed" },
        Blacklist = { glyph = "󰅚", hl = "MiniIconsRed" },
        allowlist = { glyph = "󰄬", hl = "MiniIconsGreen" },
        Allowlist = { glyph = "󰄬", hl = "MiniIconsGreen" },
        denylist = { glyph = "󰅚", hl = "MiniIconsRed" },
        Denylist = { glyph = "󰅚", hl = "MiniIconsRed" },

        -- Rate Limiting
        ["rate-limit"] = { glyph = "󰥔", hl = "MiniIconsYellow" },
        ["Rate-Limit"] = { glyph = "󰥔", hl = "MiniIconsYellow" },
        ratelimit = { glyph = "󰥔", hl = "MiniIconsYellow" },
        RateLimit = { glyph = "󰥔", hl = "MiniIconsYellow" },
        throttling = { glyph = "󰥔", hl = "MiniIconsYellow" },
        Throttling = { glyph = "󰥔", hl = "MiniIconsYellow" },
        throttle = { glyph = "󰥔", hl = "MiniIconsYellow" },
        Throttle = { glyph = "󰥔", hl = "MiniIconsYellow" },

        -- CSRF / XSS
        csrf = { glyph = "󰟵", hl = "MiniIconsRed" },
        CSRF = { glyph = "󰟵", hl = "MiniIconsRed" },
        xss = { glyph = "󰟵", hl = "MiniIconsRed" },
        XSS = { glyph = "󰟵", hl = "MiniIconsRed" },

        -- Hashing
        hash = { glyph = "󰛥", hl = "MiniIconsOrange" },
        Hash = { glyph = "󰛥", hl = "MiniIconsOrange" },
        hashing = { glyph = "󰛥", hl = "MiniIconsOrange" },
        Hashing = { glyph = "󰛥", hl = "MiniIconsOrange" },

        -- Signature
        signatures = { glyph = "󰄤", hl = "MiniIconsPurple" },
        Signatures = { glyph = "󰄤", hl = "MiniIconsPurple" },
        signature = { glyph = "󰄤", hl = "MiniIconsPurple" },
        Signature = { glyph = "󰄤", hl = "MiniIconsPurple" },

        -- Vault
        vault = { glyph = "󰌋", hl = "MiniIconsRed" },
        Vault = { glyph = "󰌋", hl = "MiniIconsRed" },
        keychain = { glyph = "󰌋", hl = "MiniIconsRed" },
        Keychain = { glyph = "󰌋", hl = "MiniIconsRed" },
        keystore = { glyph = "󰌋", hl = "MiniIconsRed" },
        Keystore = { glyph = "󰌋", hl = "MiniIconsRed" },

        -- Passwords
        passwords = { glyph = "󰌾", hl = "MiniIconsRed" },
        Passwords = { glyph = "󰌾", hl = "MiniIconsRed" },
        password = { glyph = "󰌾", hl = "MiniIconsRed" },
        Password = { glyph = "󰌾", hl = "MiniIconsRed" },

        -- Access Control / Identity
        access = { glyph = "󰋁", hl = "MiniIconsRed" },
        Access = { glyph = "󰋁", hl = "MiniIconsRed" },
        ["access-control"] = { glyph = "󰋁", hl = "MiniIconsRed" },
        ["Access-Control"] = { glyph = "󰋁", hl = "MiniIconsRed" },
        identity = { glyph = "󰋁", hl = "MiniIconsPurple" },
        Identity = { glyph = "󰋁", hl = "MiniIconsPurple" },
        identities = { glyph = "󰋁", hl = "MiniIconsPurple" },
        Identities = { glyph = "󰋁", hl = "MiniIconsPurple" },

        -- ╔══════════════════════════════════════════╗
        -- ║         API (extras que faltavam)        ║
        -- ╚══════════════════════════════════════════╝

        -- Swagger / OpenAPI
        swagger = { glyph = "󰘬", hl = "MiniIconsGreen" },
        Swagger = { glyph = "󰘬", hl = "MiniIconsGreen" },
        openapi = { glyph = "󰘬", hl = "MiniIconsGreen" },
        OpenAPI = { glyph = "󰘬", hl = "MiniIconsGreen" },
        ["open-api"] = { glyph = "󰘬", hl = "MiniIconsGreen" },
        ["Open-API"] = { glyph = "󰘬", hl = "MiniIconsGreen" },

        -- API Docs
        ["api-docs"] = { glyph = "󰘬", hl = "MiniIconsGreen" },
        ["Api-Docs"] = { glyph = "󰘬", hl = "MiniIconsGreen" },
        Api = { glyph = "󰘬", hl = "MiniIconsGreen" },
        apidocs = { glyph = "󰘬", hl = "MiniIconsGreen" },
        ApiDocs = { glyph = "󰘬", hl = "MiniIconsGreen" },

        -- Pagination
        pagination = { glyph = "󰘷", hl = "MiniIconsCyan" },
        Pagination = { glyph = "󰘷", hl = "MiniIconsCyan" },
        paginate = { glyph = "󰘷", hl = "MiniIconsCyan" },
        Paginate = { glyph = "󰘷", hl = "MiniIconsCyan" },

        -- Headers
        headers = { glyph = "󰘧", hl = "MiniIconsYellow" },
        Headers = { glyph = "󰘧", hl = "MiniIconsYellow" },
        header = { glyph = "󰘧", hl = "MiniIconsYellow" },
        Header = { glyph = "󰘧", hl = "MiniIconsYellow" },

        -- Webhooks / Callbacks
        webhooks = { glyph = "󰛢", hl = "MiniIconsPurple" },
        Webhooks = { glyph = "󰛢", hl = "MiniIconsPurple" },
        webhook = { glyph = "󰛢", hl = "MiniIconsPurple" },
        Webhook = { glyph = "󰛢", hl = "MiniIconsPurple" },
        callbacks = { glyph = "󰛢", hl = "MiniIconsPurple" },
        Callbacks = { glyph = "󰛢", hl = "MiniIconsPurple" },
        callback = { glyph = "󰛢", hl = "MiniIconsPurple" },
        Callback = { glyph = "󰛢", hl = "MiniIconsPurple" },

        -- Proxies / Gateway
        proxies = { glyph = "󰴚", hl = "MiniIconsOrange" },
        Proxies = { glyph = "󰴚", hl = "MiniIconsOrange" },
        proxy = { glyph = "󰴚", hl = "MiniIconsOrange" },
        Proxy = { glyph = "󰴚", hl = "MiniIconsOrange" },
        ["api-gateway"] = { glyph = "󰴚", hl = "MiniIconsOrange" },
        ["Api-Gateway"] = { glyph = "󰴚", hl = "MiniIconsOrange" },
        apigateway = { glyph = "󰴚", hl = "MiniIconsOrange" },
        ApiGateway = { glyph = "󰴚", hl = "MiniIconsOrange" },

        -- Health Checks (Batimento/Coração)
        health = { glyph = "󰣐", hl = "MiniIconsGreen" },
        Health = { glyph = "󰣐", hl = "MiniIconsGreen" },
        ["health-check"] = { glyph = "󰣐", hl = "MiniIconsGreen" },
        ["Health-Check"] = { glyph = "󰣐", hl = "MiniIconsGreen" },
        healthcheck = { glyph = "󰣐", hl = "MiniIconsGreen" },
        HealthCheck = { glyph = "󰣐", hl = "MiniIconsGreen" },

        -- Status
        status = { glyph = "󰣐", hl = "MiniIconsGreen" },
        Status = { glyph = "󰣐", hl = "MiniIconsGreen" },

        -- Versioning
        versioning = { glyph = "󰴚", hl = "MiniIconsCyan" },
        Versioning = { glyph = "󰴚", hl = "MiniIconsCyan" },
        version = { glyph = "󰴚", hl = "MiniIconsCyan" },
        Version = { glyph = "󰴚", hl = "MiniIconsCyan" },
        versions = { glyph = "󰴚", hl = "MiniIconsCyan" },
        Versions = { glyph = "󰴚", hl = "MiniIconsCyan" },

        -- Uploads / Downloads
        downloads = { glyph = "󰇚", hl = "MiniIconsGreen" },
        Downloads = { glyph = "󰇚", hl = "MiniIconsGreen" },
        download = { glyph = "󰇚", hl = "MiniIconsGreen" },
        Download = { glyph = "󰇚", hl = "MiniIconsGreen" },
        uploads = { glyph = "󰉍", hl = "MiniIconsOrange" },
        Uploads = { glyph = "󰉍", hl = "MiniIconsOrange" },
        upload = { glyph = "󰉍", hl = "MiniIconsOrange" },
        Upload = { glyph = "󰉍", hl = "MiniIconsOrange" },
        files = { glyph = "󰈙", hl = "MiniIconsBlue" },
        Files = { glyph = "󰈙", hl = "MiniIconsBlue" },

        -- Streams / Sockets (Ondas)
        streams = { glyph = "󰖃", hl = "MiniIconsCyan" },
        Streams = { glyph = "󰖃", hl = "MiniIconsCyan" },
        stream = { glyph = "󰖃", hl = "MiniIconsCyan" },
        Stream = { glyph = "󰖃", hl = "MiniIconsCyan" },
        sockets = { glyph = "󰖃", hl = "MiniIconsPurple" },
        Sockets = { glyph = "󰖃", hl = "MiniIconsPurple" },
        socket = { glyph = "󰖃", hl = "MiniIconsPurple" },
        Socket = { glyph = "󰖃", hl = "MiniIconsPurple" },
        websocket = { glyph = "󰖃", hl = "MiniIconsPurple" },
        WebSocket = { glyph = "󰖃", hl = "MiniIconsPurple" },
        websockets = { glyph = "󰖃", hl = "MiniIconsPurple" },
        WebSockets = { glyph = "󰖃", hl = "MiniIconsPurple" },
        ws = { glyph = "󰖃", hl = "MiniIconsPurple" },
        WS = { glyph = "󰖃", hl = "MiniIconsPurple" },

        -- REST
        rest = { glyph = "󰴚", hl = "MiniIconsCyan" },
        REST = { glyph = "󰴚", hl = "MiniIconsCyan" },
        restful = { glyph = "󰴚", hl = "MiniIconsCyan" },
        Restful = { glyph = "󰴚", hl = "MiniIconsCyan" },

        -- gRPC / Protobuf
        grpc = { glyph = "󰴚", hl = "MiniIconsBlue" },
        gRPC = { glyph = "󰴚", hl = "MiniIconsBlue" },
        protobuf = { glyph = "󰘧", hl = "MiniIconsBlue" },
        Protobuf = { glyph = "󰘧", hl = "MiniIconsBlue" },
        proto = { glyph = "󰘧", hl = "MiniIconsBlue" },
        Proto = { glyph = "󰘧", hl = "MiniIconsBlue" },

        -- Soap
        soap = { glyph = "󰴚", hl = "MiniIconsGrey" },
        SOAP = { glyph = "󰴚", hl = "MiniIconsGrey" },

        -- Microservices (Blocos/Peças independentes)
        microservices = { glyph = "󰩏", hl = "MiniIconsPurple" },
        Microservices = { glyph = "󰩏", hl = "MiniIconsPurple" },
        microservice = { glyph = "󰩏", hl = "MiniIconsPurple" },
        Microservice = { glyph = "󰩏", hl = "MiniIconsPurple" },

        -- Messaging / Brokers (Rede de Servidores)
        messaging = { glyph = "󰒋", hl = "MiniIconsYellow" },
        Messaging = { glyph = "󰒋", hl = "MiniIconsYellow" },
        message = { glyph = "󰒋", hl = "MiniIconsYellow" },
        Message = { glyph = "󰒋", hl = "MiniIconsYellow" },
        messages = { glyph = "󰒋", hl = "MiniIconsYellow" },
        Messages = { glyph = "󰒋", hl = "MiniIconsYellow" },
        broker = { glyph = "󰒋", hl = "MiniIconsYellow" },
        Broker = { glyph = "󰒋", hl = "MiniIconsYellow" },
        kafka = { glyph = "󰒋", hl = "MiniIconsGreen" },
        Kafka = { glyph = "󰒋", hl = "MiniIconsGreen" },
        rabbitmq = { glyph = "󰒋", hl = "MiniIconsOrange" },
        RabbitMQ = { glyph = "󰒋", hl = "MiniIconsOrange" },

        -- Redis
        redis = { glyph = "󰆼", hl = "MiniIconsRed" },
        Redis = { glyph = "󰆼", hl = "MiniIconsRed" },

        -- Cache dirs
        [".cache"] = { glyph = "󰆐", hl = "MiniIconsGrey" },

        -- Misc
        tmp = { glyph = "󰆐", hl = "MiniIconsGrey" },
        Tmp = { glyph = "󰆐", hl = "MiniIconsGrey" },
      },

      file = {
        [".gitignore"] = { glyph = "󰊢", hl = "MiniIconsOrange" },
        [".env"] = { glyph = "󰭂", hl = "MiniIconsYellow" },
        [".env.local"] = { glyph = "󰭂", hl = "MiniIconsYellow" },
        [".env.development"] = { glyph = "󰭂", hl = "MiniIconsGreen" },
        [".env.production"] = { glyph = "󰭂", hl = "MiniIconsRed" },
        ["docker-compose.yml"] = { glyph = "󰡨", hl = "MiniIconsBlue" },
        ["docker-compose.yaml"] = { glyph = "󰡨", hl = "MiniIconsBlue" },
        ["Dockerfile"] = { glyph = "󰡨", hl = "MiniIconsBlue" },
        ["Makefile"] = { glyph = "󰆍", hl = "MiniIconsGreen" },
        ["package.json"] = { glyph = "󰎙", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "󰛦", hl = "MiniIconsBlue" },
        ["Cargo.toml"] = { glyph = "󱘗", hl = "MiniIconsOrange" },
        ["go.mod"] = { glyph = "󰟓", hl = "MiniIconsCyan" },
        ["requirements.txt"] = { glyph = "󰌠", hl = "MiniIconsYellow" },
        ["Gemfile"] = { glyph = "󰴭", hl = "MiniIconsRed" },
      },
    },

    config = function(_, opts)
      require("mini.icons").setup(opts)
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = { "nvim-mini/mini.icons" },
    opts = {
      explorer = { hidden = true },
      picker = { hidden = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
    },
    keys = {
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete buffer",
      },
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>gl",
        function()
          Snacks.lazygit.log()
        end,
        desc = "Git log",
      },
      {
        "<leader>nh",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification history",
      },
    },
  },
}
