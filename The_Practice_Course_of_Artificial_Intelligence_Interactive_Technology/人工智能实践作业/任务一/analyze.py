import viVoicecloud as vv
import pyaudio
from sjtu.audio import findDevice



def aiui_answer(question):
    try:
        ans = vv.aiui(question)
        return ans
    except Exception as e:
        print ( 'catch error！', e)
        break

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

vv.Login()#登录
ASR=vv.asr()#实例化
t = vv.tts()
while True:
    words = asr_once_func(stream,ASR,Sample_rate,time_seconds)
    print('I:' + words)
    if "结束" in words or "停止" in words:
        break
    lst_ = aiui_answer(words)
    ans = lst_[3][0]
    if ans == '':
        print("R:听不懂，再问一个")
        t.say(text = "听不懂，再问一个", voice = "nannan")
    else:
        print("R:" + ans)
        t.say(text=ans, voice="nannan")

vv.Logout()
stream.close()
p.terminate()




