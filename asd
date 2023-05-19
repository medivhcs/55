import pygame
import random
from os import path
img_dir = path.join(path.dirname(__file__), "img")
WIDTH = 480
HEIGHT = 600
FPS = 60

#Обозначение цветов
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
RED = (255, 0, 0)
GREEN = (0, 255, 0)
YELLOW = (255, 255, 0) #Добавляем желтый для пуль (ЧАСТЬ 3)
BLUE = (0, 0, 255)

#включаем Пайгейм и создаем окно
pygame.init()
pygame.mixer.init()
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Shmup!") #Устанавливаем название для игры
clock = pygame.time.Clock()
font_name = pygame.font.match_font('arial')
def mob_add():
    m = Mob()
    all_sprites.add(m)
    mobs.add(m)
def draw_text(surf, text, size, x, y):
    font = pygame.font.Font(font_name, size)
    text_surface = font.render(text, True, WHITE)
    text_rect = text_surface.get_rect()
    text_rect.midtop = (x, y)
    surf.blit(text_surface, text_rect) 
def draw_shield(surf, x, y, pct):
    if pct <0:
        pct =0
    dlina = 100
    shirina = 10
    fill = (pct/100)*dlina
    outline = pygame.Rect(x,y,dlina,shirina)
    fill_rect = pygame.Rect(x,y,fill,shirina)
    pygame.draw.rect(surf, GREEN, fill_rect)
    pygame.draw.rect(surf, WHITE, outline, 2)
class Player(pygame.sprite.Sprite):
    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.image = pygame.transform.scale(player_img,(50,38))
        self.image.set_colorkey(BLACK)
        self.rect = self.image.get_rect()
        self.rect.centerx = WIDTH / 2
        self.rect.bottom = HEIGHT - 10
        self.speedx = 0
        self.shield = 100

    def update(self):
        self.speedx = 0
        keystate = pygame.key.get_pressed()
        if keystate[pygame.K_LEFT]: #Управление на стрелочках
            self.speedx = -5 #Скорость передвижения
        if keystate[pygame.K_RIGHT]: #Управление на стрелочках
            self.speedx = 5 #Скорость передвижения
        self.rect.x += self.speedx  
        if self.rect.right > WIDTH:
            self.rect.right = WIDTH
        if self.rect.left <0:
            self.rect.left = 0
def shoot(self):
        bullet = Bullet(self.rect.centerx, self.rect.top)
        all_sprites.add(bullet)
        bullets.add(bullet)

#создаем Мобов
class Mob(pygame.sprite.Sprite):
    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.image_orig =random.choice(meteor_images)
        self.image_orig.set_colorkey(BLACK)
        self.image = self.image_orig.copy()
        
        self.rect = self.image.get_rect()
        self.radius = int(self.rect.width * .85/2)
        self.rect.x = random.randrange(WIDTH - self.rect.width)
        self.rect.y = random.randrange(-100, -40)
        self.speedy = random.randrange(1, 8)
        self.speedx = random.randrange(-3, 3)
        self.rot = 0
        self.rot_speed = random.randrange(-15, 15)
        self.last_update = pygame.time.get_ticks()
    def rotate(self):
        now = pygame.time.get_ticks()
        if now - self.last_update > 50:
            self.last_update = now
            self.rot = (self.rot + self.rot_speed) % 360
            new_image = pygame.transform.rotate(self.image_orig, self.rot)
            old_center = self.rect.center
            self.image = new_image
            self.rect = self.image.get_rect()
            self.rect.center = old_center    

    def update(self):
        self.rotate()
        self.rect.x += self.speedx
        self.rect.y += self.speedy
        if self.rect.top > HEIGHT + 10 or self.rect.left < -25 or self.rect.right > WIDTH + 20:
            self.rect.x = random.randrange(WIDTH - self.rect.width)
            self.rect.y = random.randrange(-100, -40)
            self.speedy = random.randrange(1, 8)
class Bullet(pygame.sprite.Sprite): #СОЗДАЕМ КЛАСС ДЛЯ СТЕЛЬБЫ (ЧАСТЬ 3)
    def __init__(self, x, y):
        pygame.sprite.Sprite.__init__(self)
        self.image = bullet_img
        self.image.set_colorkey(BLACK)
        self.rect = self.image.get_rect()
        self.rect.bottom = y
        self.rect.centerx = x
        self.speedy = -10

    def update(self):
        self.rect.y += self.speedy
        #Убиваем спрайт если он достиг края экрана
        if self.rect.bottom < 0:
            self.kill() #(КОНЕЦ ЧАСТИ 3)
background =pygame.image.load(path.join(img_dir,"bHiPMju.png" ))
background_rect =background.get_rect()
player_img =pygame.image.load(path.join(img_dir,"ufoRed.png" ))
meteor_images =[]
meteor_list =["meteorBrown_big3.png","meteorBrown_big4.png","meteorBrown_med1.png","meteorBrown_med3.png","meteorBrown_small1.png","meteorBrown_small2.png","meteorBrown_tiny2.png"]
for i in meteor_list:
    meteor_images.append(pygame.image.load(path.join(img_dir,i)).convert())
bullet_img =pygame.image.load(path.join(img_dir,"laserRed08.png" ))
all_sprites = pygame.sprite.Group()
mobs = pygame.sprite.Group()
bullets = pygame.sprite.Group() #Добавляем группу для пуль (ЧАСТЬ 3)
player = Player()
all_sprites.add(player)
for i in range(8):
    m = Mob()
    all_sprites.add(m)
    mobs.add(m)
    running = True
score = 0
running = True
while running:
    #поддерживаем цикл на нужной скорости
    clock.tick(FPS)
    #Создаем инпуты (ивенты)
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        if event.type == pygame.KEYDOWN: #Создаем стрельбу на пробел (ЧАСТЬ 3)
            if event.key == pygame.K_SPACE:
                player.shoot()

    #Обновление
    all_sprites.update()

    #Проверка задела ли пуля моба
    hits = pygame.sprite.groupcollide(mobs, bullets, True, True)
    for hit in hits:
        score +=50 -hit.radius
        m = Mob()
        all_sprites.add(m)
        mobs.add(m)

    #Проверка задел ли моб игрока (ЧАСТЬ 3)
    hits = pygame.sprite.spritecollide(player, mobs, True, pygame.sprite.collide_circle)
    for hit in hits:
        player.shield -= hit.radius
        if player.shield <=0:
            running= False
        mob_add()
#Отрисовываем/Рендерим
    screen.fill(BLACK)
    screen.blit(background,background_rect)
    all_sprites.draw(screen)    
    draw_text(screen, str(score), 18, WIDTH / 2, 10)  
    draw_shield(screen, 5 , 5 , player.shield)
    # ПОСЛЕ отрисовки всего, переворачиваем экран
    pygame.display.flip()

pygame.quit()
