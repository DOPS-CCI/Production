
CLASS MyMP3Class
   INSTANCE filename AS STRING

    CLASS METHOD CREATE()
        ' Do initialization
    END METHOD




 INTERFACE MyMP3Interface

   INHERIT IUNKNOWN




    METHOD IntializeMedia(fname AS STRING)
        ' Do initialization
        filename = """" + fname + """"
    END METHOD

    METHOD OpenMedia()
        mciSendString("open " + filename + " alias mediaFile" , "", 0, 0)


    END METHOD

    METHOD CloseMedia()
         mciSendString("close mediaFile" , "", 0, 0)
    END METHOD

    METHOD PlayMedia()
        mciSendString("play mediaFile", "", 0, 0)
    END METHOD

    METHOD StopMedia()
        mciSendString("stop mediaFile", "", 0, 0)
    END METHOD

    METHOD PauseMedia()
        mciSendString("pause mediaFile", "", 0, 0)
    END METHOD

    METHOD ResumeMedia()
        mciSendString("resume mediaFile", "", 0, 0)
    END METHOD

     METHOD SeekMedia(position AS LONG)
        mciSendString("seek mediaFile to " + STR$(position), "", 0, 0)
    END METHOD

    METHOD AdjustMediaMasterVolume(vol AS LONG)
        mciSendString("setaudio mediaFile volume to " + STR$(vol), "", 0, 0)
    END METHOD

    METHOD AdjustMediaRightVolume(vol AS LONG)
        mciSendString("setaudio mediaFile right volume to " + STR$(vol), "", 0, 0)
    END METHOD

    METHOD AdjustMediaLeftVolume(vol AS LONG)
        mciSendString("setaudio mediaFile left volume to " + STR$(vol), "", 0, 0)
    END METHOD

    METHOD GetMediaPosition() AS LONG
        LOCAL iMediaLength AS LONG
        LOCAL szPosition AS ASCIIZ * 255

        mciSendString("Status mediaFile position", szPosition, 255, %NULL)

        METHOD = CLNG(VAL(szPosition))                  '
    END METHOD

    METHOD GetMediaLength() AS LONG
        LOCAL szLength AS ASCIIZ * 255

        mciSendString("Status mediaFile length", szLength, 255, %NULL)

        METHOD = CLNG(VAL(szLength))                  '
    END METHOD

 END INTERFACE

END CLASS
