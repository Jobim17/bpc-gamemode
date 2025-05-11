CREATE TABLE IF NOT EXISTS `Logs` (
  `Data` datetime NOT NULL DEFAULT current_timestamp(),
  `Tipo` varchar(32) NOT NULL,
  `Texto` varchar(256) NOT NULL
);

CREATE TABLE IF NOT EXISTS `Banimentos` (
  `Nome` varchar(24) NOT NULL UNIQUE,
  `IP` varchar(16) NOT NULL,
  `Admin` varchar(24) NOT NULL,
  `AdminID` int NOT NULL,
  `Tempo` int DEFAULT NULL,
  `Data` datetime NOT NULL DEFAULT current_timestamp()
);

CREATE TABLE IF NOT EXISTS `Contas` (
  `ID` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Nome` varchar(24) NOT NULL UNIQUE,
  `Senha` varchar(64) NOT NULL,
  `IP` varchar(16) NOT NULL,
  `Serial` varchar(40) NOT NULL,
  `Mobile` tinyint NOT NULL DEFAULT 0,
  `Cidade` varchar(64) NOT NULL DEFAULT '',
  `Estado` varchar(64) NOT NULL DEFAULT '',
  `País` varchar(64) NOT NULL DEFAULT '',
  `VPN` tinyint NOT NULL DEFAULT 0,
  `Admin` int NOT NULL DEFAULT 0,
  `AdminHide` int NOT NULL DEFAULT 0,
  `AdminViewChats` int NOT NULL DEFAULT 0,
  `AdminAvaliations` int NOT NULL DEFAULT 0,
  `AdminStars` int NOT NULL DEFAULT 0,
  `AdminTeams` int NOT NULL DEFAULT 0,
  `Premium` int NOT NULL DEFAULT 0,
  `PremiumExpires` int NOT NULL DEFAULT 0,
  `Registro` datetime NOT NULL DEFAULT current_timestamp(),
  `Login` datetime NOT NULL DEFAULT current_timestamp()
);

CREATE TABLE IF NOT EXISTS `Personagens` (
  `ID` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Conta` int NOT NULL,
  `Nome` varchar(24) NOT NULL UNIQUE,
  `Skin` int NOT NULL DEFAULT 264,
  `Dinheiro` int NOT NULL DEFAULT 350,
  `DinheiroBanco` int NOT NULL DEFAULT 1150,
  `Nível` int NOT NULL DEFAULT 1,
  `Experiência` int NOT NULL DEFAULT 0,
  `Sede` int NOT NULL DEFAULT 100,
  `Fome` int NOT NULL DEFAULT 100,
  `SpawnPoint` int NOT NULL DEFAULT 0,
  `SpawnId` int NOT NULL DEFAULT -1,
  `PosX` float NOT NULL DEFAULT 0.0,
  `PosY` float NOT NULL DEFAULT 0.0,
  `PosZ` float NOT NULL DEFAULT 0.0,
  `Angle` float NOT NULL DEFAULT 0.0,
  `Interior` int NOT NULL DEFAULT 0,
  `World` int NOT NULL DEFAULT 0,
  `Emprego` int NOT NULL DEFAULT -1,
  `EmpregoHoras` varchar(32) DEFAULT NULL,
  `Paycheck` int NOT NULL DEFAULT 0,
  `Facção` int NOT NULL DEFAULT -1,
  `FacçãoMod` int NOT NULL DEFAULT 0,
  `FacçãoRank` varchar(32) NOT NULL DEFAULT 'Membro',
  `Altura` int NOT NULL,
  `Peso` int NOT NULL,
  `Olhos` varchar(16) NOT NULL,
  `Etnia` varchar(22) NOT NULL,
  `CidadeNatal` varchar(32) NOT NULL,
  `DataNascimento` varchar(10) NOT NULL,
  `Gênero` char NOT NULL DEFAULT 'M',
  `RádioOn` char NOT NULL DEFAULT 0,
  `RádioCanais` varchar(128) NOT NULL DEFAULT '0',
  `Acesso` datetime DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS `Interações` (
  `ID` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Tipo` int NOT NULL DEFAULT 0,
  `PosX` float NOT NULL DEFAULT 0.0,
  `PosY` float NOT NULL DEFAULT 0.0,
  `PosZ` float NOT NULL DEFAULT 0.0,
  `Interior` int NOT NULL DEFAULT 0,
  `World` int NOT NULL DEFAULT 0,
  `Criado` datetime NOT NULL DEFAULT current_timestamp,
  `Criador` varchar(24) NOT NULL
);

CREATE TABLE IF NOT EXISTS `Entradas` (
  `ID` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Nome` varchar(32) NOT NULL,
  `Ícone` int NOT NULL DEFAULT 1239,
  `PosX` float NOT NULL DEFAULT 0.0,
  `PosY` float NOT NULL DEFAULT 0.0,
  `PosZ` float NOT NULL DEFAULT 0.0,
  `Interior` int NOT NULL DEFAULT 0,
  `World` int NOT NULL DEFAULT 0,
  `InsidePosX` float NOT NULL DEFAULT 0.0,
  `InsidePosY` float NOT NULL DEFAULT 0.0,
  `InsidePosZ` float NOT NULL DEFAULT 0.0,
  `InsidePosA` float NOT NULL DEFAULT 0.0,
  `InsideWorld` int NOT NULL DEFAULT 0,
  `InsideInterior` int NOT NULL DEFAULT 0,
  `Criado` datetime NOT NULL DEFAULT current_timestamp,
  `Criador` varchar(24) NOT NULL
);

CREATE TABLE IF NOT EXISTS `Indústrias` (
  `ID` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Nome` varchar(32) NOT NULL,
  `Tipo` int NOT NULL DEFAULT 0,
  `Fechado` int NOT NULL DEFAULT 0,
  `Criado` datetime NOT NULL DEFAULT current_timestamp,
  `Criador` varchar(24) NOT NULL
);

CREATE TABLE IF NOT EXISTS `IndústriaEstoque` (
  `ID` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Indústria` int NOT NULL DEFAULT 0,
  `PosX` float NOT NULL DEFAULT 0.0,
  `PosY` float NOT NULL DEFAULT 0.0,
  `PosZ` float NOT NULL DEFAULT 0.0,
  `Interior` int NOT NULL DEFAULT 0,
  `World` int NOT NULL DEFAULT 0,
  `Estoque` int NOT NULL DEFAULT 0,
  `TamanhoEstoque` int NOT NULL DEFAULT 0,
  `Consumo` int NOT NULL DEFAULT 0,
  `Produto` int NOT NULL DEFAULT 0,
  `Preço` int NOT NULL DEFAULT 0,
  `Venda` int NOT NULL DEFAULT 0,
  `Criado` datetime NOT NULL DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS `Ruas` (
  `ID` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Nome` varchar(32) NOT NULL,
  `PosX` float NOT NULL DEFAULT 0.0,
  `PosY` float NOT NULL DEFAULT 0.0,
  `PosZ` float NOT NULL DEFAULT 0.0
);

CREATE TABLE IF NOT EXISTS `Facções` (
  `ID` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Nome` varchar(32) NOT NULL DEFAULT 'N/A',
  `Abreviação` varchar(12) NOT NULL DEFAULT 'N/A',
  `CargoPadrão` varchar(32) NOT NULL DEFAULT 'Membro',
  `Cor` int NOT NULL DEFAULT -1,
  `Tipo` int NOT NULL DEFAULT 0,
  `Cofre` int NOT NULL DEFAULT 0,
  `MOTD` varchar(128) NOT NULL DEFAULT '',
  `BloquearChat` int NOT NULL DEFAULT 0,
  `Tier` int NOT NULL DEFAULT -1,
  `TierAtivo` tinyint NOT NULL DEFAULT 0,
  `Abastecimento` int NOT NULL DEFAULT 0,
  `Saldo` int NOT NULL DEFAULT 0,
  `Casa` int NOT NULL DEFAULT 0,
  `Pontos` int NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `FacçãoSpawn` (
  `ID` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Nome` varchar(32) NOT NULL DEFAULT 'N/A',
  `Facção` int NOT NULL DEFAULT 0, 
  `PosX` float NOT NULL DEFAULT '0.0',
  `PosY` float NOT NULL DEFAULT '0.0',
  `PosZ` float NOT NULL DEFAULT '0.0',
  `Angle` float NOT NULL DEFAULT '0.0',
  `World` int NOT NULL DEFAULT 0,
  `Interior` int NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `FacçãoArmário` (
  `ID` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Facção` int NOT NULL DEFAULT 0, 
  `PosX` float NOT NULL DEFAULT '0.0',
  `PosY` float NOT NULL DEFAULT '0.0',
  `PosZ` float NOT NULL DEFAULT '0.0',
  `Angle` float NOT NULL DEFAULT '0.0',
  `World` int NOT NULL DEFAULT 0,
  `Interior` int NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `FacçãoArsenal` (
  `ID` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Facção` int NOT NULL DEFAULT 0, 
  `PosX` float NOT NULL DEFAULT '0.0',
  `PosY` float NOT NULL DEFAULT '0.0',
  `PosZ` float NOT NULL DEFAULT '0.0',
  `Angle` float NOT NULL DEFAULT '0.0',
  `World` int NOT NULL DEFAULT 0,
  `Interior` int NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `Veículos` (
  `ID` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Nome` varchar(32) NOT NULL DEFAULT 'N/A',
  `Placa` varchar(16) NOT NULL DEFAULT 'N/A', 
  `Dono` int NOT NULL DEFAULT -1,
  `Tipo` int NOT NULL DEFAULT 0,
  `Modelo` int NOT NULL DEFAULT 0,
  `PosX` float NOT NULL DEFAULT '0.0',
  `PosY` float NOT NULL DEFAULT '0.0',
  `PosZ` float NOT NULL DEFAULT '0.0',
  `Angle` float NOT NULL DEFAULT '0.0',
  `World` int NOT NULL DEFAULT 0,
  `Interior` int NOT NULL DEFAULT 0,
  `Cor1` int NOT NULL DEFAULT 0,
  `Cor2` int NOT NULL DEFAULT 0,
  `Paintjob` int NOT NULL DEFAULT 0,
  `Vida` float NOT NULL DEFAULT 1000.0,
  `Quilômetros` float NOT NULL DEFAULT 0.0,
  `VidaMotor` float NOT NULL DEFAULT 100.0,
  `VidaBateria` float NOT NULL DEFAULT 100.0,
  `Combustível` float NOT NULL DEFAULT 100.0,
  `DamageDoors` int NOT NULL DEFAULT 0,
  `DamagePanels` int NOT NULL DEFAULT 0,
  `DamageLights` int NOT NULL DEFAULT 0,
  `DamageTires` int NOT NULL DEFAULT 0,
  `Seguro` int NOT NULL DEFAULT 0,
  `Alarme` int NOT NULL DEFAULT 0,
  `Imobilizador` int NOT NULL DEFAULT 0,
  `Trava` int NOT NULL DEFAULT 0,
  `Localizador` int NOT NULL DEFAULT 0,
  `Modificações` varchar(64) NOT NULL DEFAULT '0'
);

CREATE TABLE IF NOT EXISTS `Variáveis` (
  `Nome` varchar(64) NOT NULL UNIQUE,
  `Int` int DEFAULT NULL,
  `String` varchar(256) DEFAULT NULL,
  `Float` float DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS `Interiores` (
  `Nome` varchar(32) NOT NULL UNIQUE,
  `Categoria` varchar(32) NOT NULL,
  `PosX` float NOT NULL DEFAULT 0.0,
  `PosY` float NOT NULL DEFAULT 0.0,
  `PosZ` float NOT NULL DEFAULT 0.0,
  `Interior` int NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `Empresas` (
  `ID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Dono` INT NOT NULL DEFAULT 0,
  `Nome` varchar(32) NOT NULL DEFAULT 'N/A',
  `Mensagem` varchar(128) NOT NULL DEFAULT '',
  `Rádio` varchar(255) NOT NULL DEFAULT '',
  `TaxaEntrada` INT NOT NULL DEFAULT 0,
  `Preço` INT NOT NULL DEFAULT 0,
  `Tipo` INT NOT NULL DEFAULT 0,
  `Cofre` INT NOT NULL DEFAULT 0,
  `PosX` FLOAT NOT NULL DEFAULT 0.0,
  `PosY` FLOAT NOT NULL DEFAULT 0.0,
  `PosZ` FLOAT NOT NULL DEFAULT 0.0,
  `World` INT NOT NULL DEFAULT 0,
  `Interior` INT NOT NULL DEFAULT 0,
  `InsidePosX` FLOAT NOT NULL DEFAULT 0.0,
  `InsidePosY` FLOAT NOT NULL DEFAULT 0.0,
  `InsidePosZ` FLOAT NOT NULL DEFAULT 0.0,
  `InsideAngle` FLOAT NOT NULL DEFAULT 0.0,
  `InsideInterior` INT NOT NULL DEFAULT 0,
  `Aberta` INT NOT NULL DEFAULT 0,
  `Trancada` INT NOT NULL DEFAULT 0,
  `Produtos` INT NOT NULL DEFAULT 0,
  `LimiteProdutos` INT NOT NULL DEFAULT 0,
  `PedidoQuantidade` INT NOT NULL DEFAULT 0,
  `PedidoCarga` INT NOT NULL DEFAULT 0,
  `PedidoPreço` INT NOT NULL DEFAULT 0,
  `PreçoCombustível` INT NOT NULL DEFAULT 0,
  `Combustível` INT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `Itens` (
  `ID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Nome` varchar(64) NOT NULL DEFAULT 'N/A' UNIQUE,
  `Modelo` INT NOT NULL DEFAULT 0,
  `Categoria` INT NOT NULL DEFAULT 0,
  `Sub-categoria` INT NOT NULL DEFAULT 0,
  `ItemPesado` INT(1) NOT NULL DEFAULT 0,
  `OffsetAttach` VARCHAR(128) NOT NULL DEFAULT '0.0',
  `DrogaTipo` INT NOT NULL DEFAULT 0,
  `DrogaDosagem` FLOAT NOT NULL DEFAULT 0.0,
  `DrogaEfeitos` INT NOT NULL DEFAULT 0,
  `DrogaTempoEfeito` INT NOT NULL DEFAULT 0,
  `DrogaClima` INT NOT NULL DEFAULT 0,
  `DrogaHora` INT NOT NULL DEFAULT 0,
  `DrogaSkin` INT NOT NULL DEFAULT 0,
  `DrogaCorVeículo` INT NOT NULL DEFAULT 0,
  `DrogaPontosVicio` INT NOT NULL DEFAULT 0,
  `DrogaLegal` tinyint NOT NULL DEFAULT 0,
  `CaseCapacidade` INT NOT NULL DEFAULT 0,
  `CaseCompatível` INT NOT NULL DEFAULT 0,
  `CaseCigarros` INT NOT NULL DEFAULT 0,
  `SementeRequerida` INT NOT NULL DEFAULT 0,
  `SementeDrogaGerada` INT NOT NULL DEFAULT 0,
  `SementeQuantidadeGerada` INT NOT NULL DEFAULT 0,
  `SementeIngredienteGerado` INT NOT NULL DEFAULT 0,
  `SementeIngredientePorcento` INT NOT NULL DEFAULT 0,
  `SementeTempoCrescimento` INT NOT NULL DEFAULT 0,
  `SementeTempoAmadurecimento` INT NOT NULL DEFAULT 0,
  `SementeTempoMorte` INT NOT NULL DEFAULT 0,
  `RemédioDrogas` varchar(128) NOT NULL DEFAULT '0',
  `FardoItem` INT NOT NULL DEFAULT 0,
  `FardoMaxItem` INT NOT NULL DEFAULT 0,
  `BebidaTeorAlcoólico` INT NOT NULL DEFAULT 0,
  `BebidaSaciez` INT NOT NULL DEFAULT 0,
  `BebidaItemGerado` INT NOT NULL DEFAULT 0,  
  `ComidaSaciez` INT NOT NULL DEFAULT 0,
  `ComidaItemGerado` INT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `ClosedBeta` (
  `Nome` varchar(24) NOT NULL UNIQUE,
  `Admin` varchar(24) NOT NULL,
  `Data` datetime DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS `InteriorCategoria` (
  `Nome` varchar(32) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS `Interior` (
  `ID` INT AUTO_INCREMENT PRIMARY KEY,
  `Nome` varchar(32) NOT NULL,
  `Categoria` varchar(32) NOT NULL,
  `PosX` FLOAT NOT NULL,
  `PosY` FLOAT NOT NULL,
  `PosZ` FLOAT NOT NULL,
  `Interior` INT NOT NULL,
  UNIQUE (`Nome`, `Categoria`),
  FOREIGN KEY (Categoria) REFERENCES InteriorCategoria(Nome) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `Casas` (
  `ID` INT AUTO_INCREMENT PRIMARY KEY,
  `Dono` INT NOT NULL DEFAULT 0,
  `Preço` INT NOT NULL DEFAULT 0,
  `PreçoAluguel` INT NOT NULL DEFAULT 0,
  `Rádio` varchar(255) NOT NULL DEFAULT '',
  `PosX` FLOAT NOT NULL DEFAULT 0.0,
  `PosY` FLOAT NOT NULL DEFAULT 0.0,
  `PosZ` FLOAT NOT NULL DEFAULT 0.0,
  `World` INT NOT NULL DEFAULT 0,
  `Interior` INT NOT NULL DEFAULT 0,
  `InsidePosX` FLOAT NOT NULL DEFAULT 0.0,
  `InsidePosY` FLOAT NOT NULL DEFAULT 0.0,
  `InsidePosZ` FLOAT NOT NULL DEFAULT 0.0,
  `InsideAngle` FLOAT NOT NULL DEFAULT 0.0,
  `InsideInterior` INT NOT NULL DEFAULT 0,
  `GaragePosX` FLOAT NOT NULL DEFAULT 0.0,
  `GaragePosY` FLOAT NOT NULL DEFAULT 0.0,
  `GaragePosZ` FLOAT NOT NULL DEFAULT 0.0,
  `Dinheiro` INT NOT NULL DEFAULT 0,
  `Trancada` tinyint NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `Inventário` (
  `ID` INT AUTO_INCREMENT PRIMARY KEY,
  `Personagem` int NOT NULL,
  `Item` int NOT NULL,
  `Quantidade` int NOT NULL DEFAULT 1,
  `Drogas` varchar(128) NOT NULL DEFAULT '0',
  `DrogaQuantidade` varchar(128) NOT NULL DEFAULT '0',
  `Cigarros` INT NOT NULL DEFAULT 0,
  UNIQUE(`Personagem`, `Item`),
  FOREIGN KEY (Personagem) REFERENCES Personagens(ID) ON DELETE CASCADE,
  FOREIGN KEY (Item) REFERENCES Itens(ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `EmpresaItens` (
  `Tipo` int NOT NULL,
  `Item` int NOT NULL,
  UNIQUE(`Tipo`, `Item`),
  FOREIGN KEY (Item) REFERENCES Itens(ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `EmpresaPreços` (
  `Empresa` int NOT NULL,
  `Item` int NOT NULL,
  `Preço` int NOT NULL,
  UNIQUE(`Empresa`, `Item`),
  FOREIGN KEY (Item) REFERENCES Itens(ID) ON DELETE CASCADE,
  FOREIGN KEY (Empresa) REFERENCES Empresas(ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `Bombas` (
  `ID` int AUTO_INCREMENT PRIMARY KEY,
  `Empresa` int NOT NULL DEFAULT -1,
  `PosX` FLOAT NOT NULL DEFAULT '0.0',
  `PosY` FLOAT NOT NULL DEFAULT '0.0',
  `PosZ` FLOAT NOT NULL DEFAULT '0.0',
  `Rot` FLOAT NOT NULL DEFAULT '0.0',
  `World` INT NOT NULL DEFAULT 0,
  `Interior` INT NOT NULL DEFAULT 0,
  FOREIGN KEY (Empresa) REFERENCES Empresas(ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `AtividadeSuspeita` (
  `ID` INT AUTO_INCREMENT PRIMARY KEY,
  `Conta` INT NOT NULL DEFAULT -1,
  `Título` varchar(128) NOT NULL DEFAULT '',
  `Texto` varchar(1024) NOT NULL DEFAULT '',
  `Data` datetime NOT NULL DEFAULT current_timestamp,
  FOREIGN KEY (Conta) REFERENCES Contas(ID) ON DELETE CASCADE  
);

CREATE TABLE IF NOT EXISTS `Mobílias` (
  `ID` INT AUTO_INCREMENT PRIMARY KEY,
  `Nome` varchar(64) NOT NULL DEFAULT '',
  `Modelo` INT NOT NULL DEFAULT 0,
  `Texturas` varchar(64) NOT NULL DEFAULT '',
  `Cores` varchar(64) NOT NULL DEFAULT '',
  `PosX` FLOAT NOT NULL DEFAULT 0.0,
  `PosY` FLOAT NOT NULL DEFAULT 0.0,
  `PosZ` FLOAT NOT NULL DEFAULT 0.0,
  `RotX` FLOAT NOT NULL DEFAULT 0.0,
  `RotY` FLOAT NOT NULL DsEFAULT 0.0,
  `RotZ` FLOAT NOT NULL DEFAULT 0.0,
  `PortaTrancada` tinyint NOT NULL DEFAULT 0,
  `PortaAberta` tinyint NOT NULL DEFAULT 0,
  `PortaPosX` FLOAT NOT NULL DEFAULT 0.0,
  `PortaPosY` FLOAT NOT NULL DEFAULT 0.0,
  `PortaPosZ` FLOAT NOT NULL DEFAULT 0.0,
  `PortaRotX` FLOAT NOT NULL DEFAULT 0.0,
  `PortaRotY` FLOAT NOT NULL DEFAULT 0.0,
  `PortaRotZ` FLOAT NOT NULL DEFAULT 0.0,
  `Preço` INT NOT NULL DEFAULT 0,
  `Tipo` INT NOT NULL DEFAULT 0,
  `Propriedade` INT NOT NULL DEFAULT 0
);