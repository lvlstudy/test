# -*- coding: utf-8 -*-
# @Author : ZX
# @File : 坦克大战
# @Software: PyCharm
# @Date : 2024/4/27


# 导入模块
import pygame, time, random
from pygame.sprite import Sprite
SCREEN_WIDTH = 800  # 宽度
SCREEN_HEIGHT = 500  # 高度
BG_COLOR = pygame.Color(0, 0, 0)  # 颜色
TEXT_COLOR = pygame.Color(255, 0, 0)  # 字体颜色


class Baseitem(Sprite):
    def __init__(self, color, width, height):
        pygame.sprite.Sprite.__init__(self)

# 坦克类
class MainGame():
    window = None
    my_tank = None
    enemyTankList = []  # 敌方坦克列表
    enemyTankCount = 5  # 敌方坦克数量
    myBulletList = []  # 我方坦克子弹列表
    enemyBulletList = []  # 敌方坦克子弹列表
    explodeList = []  # 爆炸效果列表
    WallList = []  # 墙壁列表

    def __init__(self):
        pass

    # 开始游戏
    def startGame(self):
        pygame.display.init()  # 加载主窗口
        MainGame.window = pygame.display.set_mode([SCREEN_WIDTH, SCREEN_HEIGHT])  # 设置窗口大小并显示
        self.createMytank()
        self.createEnemyTank()  # 初始化敌方坦克
        self.createWall()  # 初始化墙壁
        # 窗口标题设置
        pygame.display.set_caption('坦克大战')
        while True:
            time.sleep(0.02)
            # 颜色填充
            MainGame.window.fill(BG_COLOR)
            # 获取事件
            self.getEvent()
            # 绘制文字
            MainGame.window.blit(self.getTextSuface('敌方坦克剩余数量%d' % len(MainGame.enemyTankList)), (10, 10))
            if MainGame.my_tank and MainGame.my_tank.live:
                MainGame.my_tank.displayTank()  # 展示我方坦克
            else:
                del MainGame.my_tank  # 删除我方坦克
                MainGame.my_tank = None
            self.blitEnemyTank()  # 展示敌方坦克
            self.blitMyBullet()  # 我方坦克子弹
            self.blitEnemyBullet()  # 展示敌方子弹
            self.blitExplode()  # 爆炸效果展示
            self.blitWall()  # 展示墙壁
            if MainGame.my_tank and MainGame.my_tank.live:
                if not MainGame.my_tank.stop:
                    MainGame.my_tank.move()  # 调用坦克移动方法
                    MainGame.my_tank.hitWall()
                    MainGame.my_tank.myTank_hit_enemyTank()
            pygame.display.update()

    def blitWall(self):
        for wall in MainGame.WallList:
            if wall.live:
                wall.displayWall()
            else:
                MainGame.WallList.remove(wall)

    def createWall(self):  # 初始化墙壁
        for i in range(6):
            wall = Wall(i * 145, 220)
            MainGame.WallList.append(wall)

    def createMytank(self):  # 初始化我方坦克
        MainGame.my_tank = MyTank(350, 300)
        music = Music('img/start.wav')  # 创建音乐对象
        music.play()  # 播放音乐

    def createEnemyTank(self):  # 初始化敌方坦克, 将敌方坦克添加到列表中
        top = 100
        for i in range(self.enemyTankCount):  # 生成指定敌方坦克数量
            left = random.randint(0, 600)
            speed = random.randint(1, 4)
            enemy = EnemyTank(left, top, speed)
            MainGame.enemyTankList.append(enemy)

    def blitEnemyTank(self):
        for enemyTank in MainGame.enemyTankList:
            if enemyTank.live:  # 判断敌方坦克状态
                enemyTank.displayTank()
                enemyTank.randMove()  # 调用子弹移动
                enemyTank.hitWall()
                if MainGame.my_tank and MainGame.my_tank.live:
                    enemyTank.enemyTank_hit_myTank()
                enemyBullet = enemyTank.shot()  # 敌方坦克射击
                if enemyBullet:  # 判断敌方坦克子弹是否为None
                    MainGame.enemyBulletList.append(enemyBullet)  # 存储敌方坦克子弹
            else:
                MainGame.enemyTankList.remove(enemyTank)

    def blitExplode(self):
        for expolde in MainGame.explodeList:
            if expolde.live:
                expolde.displayExplode()
            else:
                MainGame.explodeList.remove(expolde)

    def blitMyBullet(self):  # 循环我方子弹列表, 并展示
        for myBullet in MainGame.myBulletList:
            if myBullet.live:  # 判断子弹的状态
                myBullet.displayBullet()
                myBullet.move()
                myBullet.myBullet_hit_enemyTank()
                myBullet.hitWall()  # 检测我方坦克子弹是否碰撞
            else:
                MainGame.myBulletList.remove(myBullet)

    def blitEnemyBullet(self):  # 循环敌方子弹列表, 并展示
        for enemyBullet in MainGame.enemyBulletList:
            if enemyBullet.live:
                enemyBullet.displayBullet()
                enemyBullet.move()
                enemyBullet.enemyBullet_hit_myTank()
                enemyBullet.hitWall()  # 检测敌方坦克子弹是否碰撞
            else:
                MainGame.enemyBulletList.remove(enemyBullet)

    # 结束游戏
    def endGame(self):
        print('游戏结束')
        exit()  # 退出游戏

    # 文字显示
    def getTextSuface(self, text):
        pygame.font.init()  # 字体初始化
        font = pygame.font.SysFont('kaiti', 16)
        # 绘制文字信息
        textSurface = font.render(text, True, TEXT_COLOR)
        return textSurface

    # 事件获取
    def getEvent(self):
        # 获取所有事件
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                # 退出游戏
                self.endGame()
            # 键盘按键
            if event.type == pygame.KEYDOWN:
                if not MainGame.my_tank:  # 当我方坦克不存在时, 按下Esc键重生
                    if event.key == pygame.K_ESCAPE:
                        self.createMytank()
                if MainGame.my_tank and MainGame.my_tank.live:
                    # 上、下、左、右键的判断
                    if event.key == pygame.K_LEFT:
                        MainGame.my_tank.direction = 'L'
                        MainGame.my_tank.stop = False
                        print('左键, 坦克向左移动')
                    elif event.key == pygame.K_RIGHT:
                        MainGame.my_tank.direction = 'R'
                        MainGame.my_tank.stop = False
                        print('右键, 坦克向右移动')
                    elif event.key == pygame.K_UP:
                        MainGame.my_tank.direction = 'U'
                        MainGame.my_tank.stop = False
                        print('上键, 坦克向上移动')
                    elif event.key == pygame.K_DOWN:
                        MainGame.my_tank.direction = 'D'
                        MainGame.my_tank.stop = False
                        print('下键, 坦克向下移动')
                    elif event.key == pygame.K_SPACE:
                        print('发射子弹')
                        if len(MainGame.myBulletList) < 3:  # 可以同时发射子弹数量的上限
                            myBullet = Bullet(MainGame.my_tank)
                            MainGame.myBulletList.append(myBullet)
                            music = Music('img/fire.wav')
                            music.play()
            # 松开键盘, 坦克停止移动
            if event.type == pygame.KEYUP:
                # 只有松开上、下、左、右键时坦克才停止, 松开空格键坦克不停止
                if event.key == pygame.K_UP or event.key == pygame.K_DOWN or event.key == pygame.K_LEFT or event.key == pygame.K_RIGHT:
                    if MainGame.my_tank and MainGame.my_tank.live:
                        MainGame.my_tank.stop = True


# 坦克类
class Tank(Baseitem):
    def __init__(self, left, top):
        # 保存加载的图片
        self.images = {
            'U': pygame.image.load('img/p1tankU.gif'),
            'D': pygame.image.load('img/p1tankD.gif'),
            'L': pygame.image.load('img/p1tankL.gif'),
            'R': pygame.image.load('img/p1tankR.gif'),
        }
        self.direction = 'L'  # 方向
        self.image = self.images[self.direction]  # 根据图片方向获取图片
        self.rect = self.image.get_rect()  # 根据图片获取区域
        self.rect.left, self.rect.top = left, top
        self.speed = 5  # 移动速度
        self.stop = True  # 坦克移动开关
        self.live = True
        self.OldLeft = self.rect.left
        self.OldTop = self.rect.top

    # 移动
    def move(self):
        self.OldLeft = self.rect.left
        self.OldTop = self.rect.top
        # 判断坦克方向进行移动
        if self.direction == 'L':
            if self.rect.left > 0:
                self.rect.left -= self.speed
        elif self.direction == 'U':
            if self.rect.top > 0:
                self.rect.top -= self.speed
        elif self.direction == 'D':
            if self.rect.top + self.rect.height < SCREEN_HEIGHT:
                self.rect.top += self.speed
        elif self.direction == 'R':
            if self.rect.left + self.rect.height < SCREEN_WIDTH:
                self.rect.left += self.speed

    # 射击
    def shot(self):
        return Bullet(self)

    def stay(self):
        self.rect.left = self.OldLeft
        self.rect.top = self.OldTop

    def hitWall(self):
        for wall in MainGame.WallList:
            if pygame.sprite.collide_rect(self, wall):
                self.stay()

    # 展示坦克的方法
    def displayTank(self):
        # 获取展示对象
        self.image = self.images[self.direction]
        # 调用blit展示
        MainGame.window.blit(self.image, self.rect)


# 我方坦克
class MyTank(Tank):
    def __init__(self, left, top):
        super(MyTank, self).__init__(left, top)

    def myTank_hit_enemyTank(self):
        for enemyTank in MainGame.enemyTankList:
            if pygame.sprite.collide_rect(self, enemyTank):
                self.stay()


# 敌方坦克
class EnemyTank(Tank):
    def __init__(self, left, top, speed):
        super(EnemyTank, self).__init__(left, top)
        # 加载图片集
        self.images = {
            'U': pygame.image.load('img/enemy1U.gif'),
            'D': pygame.image.load('img/enemy1D.gif'),
            'L': pygame.image.load('img/enemy1L.gif'),
            'R': pygame.image.load('img/enemy1R.gif'),
        }
        # 随机生成方向
        self.direction = self.randDirection()
        self.image = self.images[self.direction]  # 根据方向获取图片
        self.rect = self.image.get_rect()  # 获取区域
        self.rect.left, self.rect.top = left, top  # 对left和top赋值
        self.speed = speed  # 速度
        self.flag = True  # 坦克移动开关
        self.step = 50  # 敌方坦克步数

    def enemyTank_hit_myTank(self):
        if pygame.sprite.collide_rect(self, MainGame.my_tank):
            self.stay()

    def randDirection(self):
        nums = random.randint(1, 4)  # 生成1~4的随机整数
        if nums == 1:
            return "U"
        elif nums == 2:
            return "D"
        elif nums == 3:
            return "L"
        elif nums == 4:
            return "R"

    def randMove(self):  # 坦克的随机方向移动
        if self.step < 0:  # 步数小于0, 随机改变方向
            self.direction = self.randDirection()
            self.step = 50  # 步数复位
        else:
            self.move()
            self.step -= 1

    def shot(self):  # 重写shot方法
        num = random.randint(1, 100)
        if num < 10:
            return Bullet(self)


# 子弹类
class Bullet(Baseitem):
    def __init__(self, tank):
        self.image = pygame.image.load('img/enemymissile.gif')  # 图片加载
        self.direction = tank.direction  # 子弹的方向
        self.rect = self.image.get_rect()  # 获取区域
        if self.direction == 'U':  # 子弹的left和top与方向有关
            self.rect.left = tank.rect.left + tank.rect.width / 2 - self.rect.width / 2
            self.rect.top = tank.rect.top - self.rect.height
        elif self.direction == 'D':
            self.rect.left = tank.rect.left + tank.rect.width / 2 - self.rect.width / 2
            self.rect.top = tank.rect.top + tank.rect.height
        elif self.direction == 'L':
            self.rect.left = tank.rect.left - self.rect.width / 2 - self.rect.width / 2
            self.rect.top = tank.rect.top + tank.rect.width / 2 - self.rect.width / 2
        elif self.direction == 'R':
            self.rect.left = tank.rect.left + tank.rect.width
            self.rect.top = tank.rect.top + tank.rect.width / 2 - self.rect.width / 2
        self.speed = 5   # 子弹的速度
        self.live = True  # 子弹的状态

    # 移动
    def move(self):
        if self.direction == 'U':
            if self.rect.top > 0:
                self.rect.top -= self.speed
            else:
                self.live = False  # 修改子弹的状态
        elif self.direction == 'R':
            if self.rect.left + self.rect.width < SCREEN_WIDTH:
                self.rect.left += self.speed
            else:
                self.live = False  # 修改子弹的状态
        elif self.direction == 'D':
            if self.rect.top + self.rect.height < SCREEN_HEIGHT:
                self.rect.top += self.speed
            else:
                self.live = False  # 修改子弹的状态
        elif self.direction == 'L':
            if self.rect.left > 0:
                self.rect.left -= self.speed
            else:
                self.live = False  # 修改子弹的状态

    def hitWall(self):
        for wall in MainGame.WallList:  # 循环遍历墙壁列表
            if pygame.sprite.collide_rect(self, wall):  # 检测子弹是否碰撞墙壁
                self.live = False  # 修改子弹状态
                wall.hp -= 1  # 碰撞后墙壁生命值减少
                if wall.hp <= 0:
                    wall.live = False

    # 子弹展示
    def displayBullet(self):
        # 将图片加载到窗口
        MainGame.window.blit(self.image, self.rect)

    def myBullet_hit_enemyTank(self):
        for enemyTank in MainGame.enemyTankList:
            if pygame.sprite.collide_rect(enemyTank, self):
                enemyTank.live = False
                self.live = False
                explode = Explode(enemyTank)
                MainGame.explodeList.append(explode)

    def enemyBullet_hit_myTank(self):
        if MainGame.my_tank and MainGame.my_tank.live:
            if pygame.sprite.collide_rect(MainGame.my_tank, self):
                explode = Explode(MainGame.my_tank)  # 爆炸对象
                MainGame.explodeList.append(explode)  # 将爆炸对象添加到爆炸列表中
                self.live = False  # 修改敌方子弹的状态
                MainGame.my_tank.live = False  # 我方坦克的状态


# 墙壁类
class Wall():
    def __init__(self, left, top):
        self.image = pygame.image.load('img/steels.gif')  # 加载墙壁图片
        self.rect = self.image.get_rect()  # 获取区域
        self.rect.left, self.rect.top = left, top  # 设置left, top
        self.live = True  # 存活状态
        self.hp = 3  # 设置墙壁生命值

    # 展示墙壁
    def displayWall(self):
        MainGame.window.blit(self.image, self.rect)


# 爆炸类
class Explode():
    def __init__(self, tank):
        self.rect = tank.rect
        self.images = [
            pygame.image.load('img/blast0.gif'),
            pygame.image.load('img/blast1.gif'),
            pygame.image.load('img/blast2.gif'),
            pygame.image.load('img/blast3.gif'),
            pygame.image.load('img/blast4.gif'),
        ]
        self.step = 0
        self.image = self.images[self.step]
        self.live = True

    # 爆炸效果
    def displayExplode(self):
        if self.step < len(self.images):
            self.image = self.images[self.step]
            self.step += 1
            MainGame.window.blit(self.image, self.rect)  # 添加到主窗口
        else:
            self.live = False
            self.step = 0


# 音效类
class Music():
    def __init__(self, filename):
        self.filename = filename
        pygame.mixer.init()
        pygame.mixer.music.load(self.filename)  # 加载音乐

    # 音乐播放
    def play(self):
        pygame.mixer.music.play()


if __name__ == '__main__':
    MainGame().startGame()
