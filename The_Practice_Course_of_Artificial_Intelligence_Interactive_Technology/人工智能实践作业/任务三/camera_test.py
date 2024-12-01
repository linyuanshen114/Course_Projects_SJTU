import cv2
import viVoicecloud as vv
import pyaudio
from sjtu.audio import findDevice


def asr_once_func(stream, ASR, Sample_rate,time_seconds):
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
time_seconds = 0.2  #录音片段的时长，建议设为0.2-0.5秒

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
index = 1
while True:
    words = asr_once_func(stream,ASR,Sample_rate,time_seconds)
    print('I:' + words)

    if '开启摄像头' in words:
        cap = cv2.VideoCapture(0)
        width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
        height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    while cap.isOpened():
        words = asr_once_func(stream, ASR,Sample_rate, time_seconds)
        print('I:' + words)
        ret, frame = cap.read()

        #gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

        cv2.imshow('frame', frame)

        if "拍照" in words:
            cv2.imwrite('image'+str(index)+'.jpg', frame)
            index += 1
        cv2.waitKey(2000)


        if "退出摄像头" in words:
            cap.release()
            cv2.destroyAllWindows()
            break
    if "退出" in words:
        break
vv.Logout()
stream.close()
p.terminate()