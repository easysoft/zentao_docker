export OPEN_VER := $(shell grep open VERSION | cut -d '=' -f 2)
export BIZ_VER := $(shell grep ^biz VERSION | cut -d '=' -f 2)
export MAX_VER := $(shell grep max VERSION | cut -d '=' -f 2)
export LITE_VER := $(shell grep "lite=" VERSION | cut -d '=' -f 2)
export LITEBIZ_VER := $(shell grep litebiz VERSION | cut -d '=' -f 2)
export BUILD_DATE := $(shell date +'%Y%m%d')

help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build-all: build build-biz build-max build-lite build-litebiz ## 构建禅道所有版本镜像

build: ## 构建开源版镜像
	docker build --build-arg VERSION=$(OPEN_VER) -t hub.qucheng.com/app/zentao:$(OPEN_VER)-$(BUILD_DATE) -f Dockerfile .

build-biz: ## 构建企业版镜像
	docker build --build-arg VERSION=$(BIZ_VER) -t hub.qucheng.com/app/zentao:$(BIZ_VER)-$(BUILD_DATE) -f Dockerfile .

build-max: ## 构建旗舰版镜像
	docker build --build-arg VERSION=$(MAX_VER) -t hub.qucheng.com/app/zentao:$(MAX_VER)-$(BUILD_DATE) -f Dockerfile .

build-lite: ## 构建迅捷版
	docker build --build-arg VERSION=$(LITE_VER) -t hub.qucheng.com/app/zentao:$(LITE_VER)-$(BUILD_DATE) -f Dockerfile .

build-litebiz: ## 构建旗迅捷企业版
	docker build --build-arg VERSION=$(LITEBIZ_VER) -t hub.qucheng.com/app/zentao:$(LITEBIZ_VER)-$(BUILD_DATE) -f Dockerfile .

docker-push-all: docker-push docker-push-biz docker-push-max docker-push-lite docker-push-litebiz ## 将所有镜像push到 hub.docker.com 镜像仓库

push-all: push push-biz push-max push-lite push-litebiz ## 将所有镜像push到 hub.qucheng.com 镜像仓库

push: ## push 禅道开源版 --> hub.qucheng.com
	docker push hub.qucheng.com/app/zentao:$(OPEN_VER)-$(BUILD_DATE)

push-biz: ## push 禅道企业版 --> hub.qucheng.com
	docker push hub.qucheng.com/app/zentao:$(BIZ_VER)-$(BUILD_DATE)

push-max: ## push 禅道旗舰版 --> hub.qucheng.com
	docker push hub.qucheng.com/app/zentao:$(MAX_VER)-$(BUILD_DATE)

push-lite: ## push 禅道迅捷版 --> hub.qucheng.com
	docker push hub.qucheng.com/app/zentao:$(LITE_VER)-$(BUILD_DATE)

push-litebiz: ## push 禅道迅捷企业版 --> hub.qucheng.com
	docker push hub.qucheng.com/app/zentao:$(LITEBIZ_VER)-$(BUILD_DATE)

docker-push: ## push 禅道开源版 --> hub.docker.com
	docker tag hub.qucheng.com/app/zentao:$(OPEN_VER)-$(BUILD_DATE) easysoft/zentao:$(OPEN_VER)-$(BUILD_DATE)
	docker tag easysoft/zentao:$(OPEN_VER)-$(BUILD_DATE) easysoft/zentao:latest
	docker push easysoft/zentao:$(OPEN_VER)-$(BUILD_DATE)
	docker push easysoft/zentao:latest

docker-push-biz: ## push 禅道企业版 --> hub.docker.com
	docker tag hub.qucheng.com/app/zentao:$(BIZ_VER)-$(BUILD_DATE) easysoft/zentao:$(BIZ_VER)-$(BUILD_DATE)
	docker push easysoft/zentao:$(BIZ_VER)-$(BUILD_DATE)

docker-push-max: ## push 禅道旗舰版 --> hub.docker.com
	docker tag hub.qucheng.com/app/zentao:$(MAX_VER)-$(BUILD_DATE) easysoft/zentao:$(MAX_VER)-$(BUILD_DATE)
	docker push  easysoft/zentao:$(MAX_VER)-$(BUILD_DATE)

docker-push-lite: ## push 禅道迅捷版 --> hub.docker.com
	docker tag hub.qucheng.com/app/zentao:$(LITE_VER)-$(BUILD_DATE) easysoft/zentao:$(LITE_VER)-$(BUILD_DATE)
	docker push easysoft/zentao:$(LITE_VER)-$(BUILD_DATE)

docker-push-litebiz: ## push 禅道迅捷企业版 --> hub.docker.com
	docker tag hub.qucheng.com/app/zentao:$(LITEBIZ_VER)-$(BUILD_DATE) easysoft/zentao:$(LITEBIZ_VER)-$(BUILD_DATE)
	docker push easysoft/zentao:$(LITEBIZ_VER)-$(BUILD_DATE)

run: ## 运行禅道开源版
	export TAG=$(OPEN_VER)-$(BUILD_DATE); docker-compose -f docker-compose.yml up -d

run-biz: ## 运行禅道企业版
	export TAG=$(BIZ_VER)-$(BUILD_DATE); docker-compose -f docker-compose.yml up -d

run-max: ## 运行禅道旗舰版
	export TAG=$(MAX_VER)-$(BUILD_DATE); docker-compose -f docker-compose.yml up -d

run-lite: ## 运行禅道迅捷版
	export TAG=$(LITE_VER)-$(BUILD_DATE);docker-compose -f docker-compose.yml up -d

run-litebiz: ## 运行禅道迅捷企业版
	export TAG=$(LITEBIZ_VER)-$(BUILD_DATE);docker-compose -f docker-compose.yml up -d

ps: ## 运行状态
	docker-compose -f docker-compose.yml ps

stop: ## 停服务
	docker-compose -f docker-compose.yml stop
	docker-compose -f docker-compose.yml rm -f

restart: build clean ps ## 重构

clean: stop ## 停服务
	docker-compose -f docker-compose.yml down
	docker volume prune -f

logs: ## 查看运行日志
	docker-compose -f docker-compose.yml logs
