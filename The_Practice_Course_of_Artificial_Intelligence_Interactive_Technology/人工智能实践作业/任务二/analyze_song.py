import urllib.parse as parse
from urllib.request import urlretrieve
import requests
import json
import os
import time
import sys
import viVoicecloud as vv
import vlc
from sjtu.audio import findDevice
import pyaudio
import hashlib
import requests




def asr_once_func(stream, ASR, Sample_rate, time_seconds):
    ASR.SessionBegin(language='Chinese')  # 开始语音识别

    stream.start_stream()
    print('***Listening...')

    # 录音并上传到讯飞，当判定一句话已经结束时，status返回3
    status = 0
    while status != 3:
        frames = stream.read(int(Sample_rate * time_seconds))
        ret, status, recStatus = ASR.AudioWrite(frames)

    stream.stop_stream()
    print('---GetResult...')

    words = ASR.GetResult()  # 获取结果
    ASR.SessionEnd()  # 结束语音识别
    return words



device_in = findDevice("ac108","input")
Sample_channels = 1
Sample_rate = 16000
Sample_width = 2
time_seconds = 0.5  #录音片段的时长，建议设为0.2-0.5秒

p = pyaudio.PyAudio()  #实例化
stream = p.open(
            rate=Sample_rate,
            format=p.get_format_from_width(Sample_width),
            channels=Sample_channels,
            input=True,
            input_device_index=device_in,
            start = False)

def qianqian_search(keyword):
    url = "https://music.taihe.com/v1/search"
    appid = "16073360"
    secret = "0b50b02fd0d73a9c4c8c3a781c30845f"
    timestamp = str(int(time.time()))
    word = keyword

    #注意参数按照字母升序排列拼接(大写在前)
    params = "appid=" + appid + "&timestamp=" + timestamp + "&word=" + word 

    MD5 = hashlib.md5()
    MD5.update((params+secret).encode("utf-8"))    
    sign = MD5.hexdigest()

    fullUrl = url + "?" + params + "&sign=" + sign

    try:
        response = requests.get(fullUrl)
        response_dict = response.json()
        songID = response_dict["data"]["typeTrack"][0]["TSID"]
        return songID
    except:
        return None

def qianqian_getLink(songID):
    url = "https://music.taihe.com/v1/song/tracklink"
    appid = "16073360"
    secret = "0b50b02fd0d73a9c4c8c3a781c30845f"
    timestamp = str(int(time.time()))
    TSID = songID

    #注意参数按照字母升序排列拼接(大写在前)
    params = "TSID=" + TSID + "&appid=" + appid + "&timestamp=" + timestamp 

    MD5 = hashlib.md5()
    MD5.update((params+secret).encode("utf-8"))    
    sign = MD5.hexdigest()

    fullUrl = url + "?" + params + "&sign=" + sign

    try:
        response = requests.get(fullUrl)
        response_dict = response.json()

        isVip = response_dict["data"]["isVip"]

        if isVip:
            # VIP歌曲，可以获取30秒试听链接
            return response_dict["data"]["trail_audio_info"]["path"]
        else:
            return response_dict["data"]["path"]

    except:
        return None


vv.Login()#登录
ASR=vv.asr()#实例化
t = vv.tts()
switch = True
print('R:点歌，请说歌名')
t.say(text='点歌，请说歌名',voice='nannan')
while True:
    try:
        song = asr_once_func(stream,ASR,Sample_rate,time_seconds)
        print(song)
        print('I:' + song)
        if switch == True:
            songID = qianqian_search(song)
            if songID:
                songLink = qianqian_getLink(songID)
                if songLink:
                    print('R:已找到歌曲')
                    switch = False
                    t.say(text='开始播放' + song,voice='nannan')
                    mp = vlc.MediaPlayer(songLink)
                    mp.play()
                else:
                    print("R:没有播放源")
                    t.say(text='没有播放源' + song,voice='nannan')
            else:
                print("R:未找到歌曲") 
                t.say(text='未找到歌曲' + song,voice='nannan')
        if switch == False:
            if "停止" in song:
                mp.pause()
                print('R:放歌停止')
                t.say(text='放歌停止',voice='nannan')
            if "继续" in song:
                print('R:放歌继续')
                t.say(text='放歌继续',voice='nannan')
                mp.play()
            if "换歌" in song:
                mp.stop()
                switch = True
                print('R:换歌，请说歌名')
                t.say(text='换歌，请说歌名',voice='nannan')
        if "结束" in song:
            print("R:放歌结束")
            t.say(text='放歌结束',voice='nannan')
            break
    except Exception as e:
        print ( '发现错误！停止！', e)
        break
mp.release()
vv.Logout()
stream.close()
p.terminate()




