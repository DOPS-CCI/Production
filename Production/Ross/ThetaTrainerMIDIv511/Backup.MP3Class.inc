
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
        mciSendString("set audio all on",  "", 0, 0)

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

    METHOD AdjustMediaMasterVolume(vol AS LONG)
        mciSendString("set audio mediaFile right volume to " + STR$(vol), "", 0, 0)
        mciSendString("set audio mediaFile left volume to " + STR$(vol), "", 0, 0)
    END METHOD

 END INTERFACE

END CLASS
