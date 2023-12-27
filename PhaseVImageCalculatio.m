function gfcn_PhaseVImg=PhaseVImageCalculatios(gfcn_StaDist,WinWave,cross_NumCtrT,g_WinMinPtNum,g_WinMaxPtNum,VImgPt,ImageData,InitialX,InitialY,SampleF,StartT,EndT,DeltaT,WinMinV,WinMaxV,DeltaV,df_freq,g_WindnumT,g_Winmintime)
    
    WinWave=reshape(WinWave,1,length(WinWave))
    YSize = size(ImageData, 1);
    XSize = size(ImageData, 2);

    ArrPt = zeros(1,XSize);

    % Center_T search up
    step = 3;
    point_left = 0;
    point_right = 0;

    for i = InitialX:XSize
        index1 = 0;
        index2 = 0; 
        point_left = InitialY;
        point_right = InitialY;
        while index1 == 0
            point_left_new = max(1, point_left - step);
            
            
            if ImageData(point_left,i) < ImageData(point_left_new,i)
              point_left = point_left_new;
    %          point_right = point_right - step;
            else
               index1 = 1;
               point_left = point_left_new;
            end
        end
        while index2 == 0
            point_right_new = min(point_right + step, YSize);
            if ImageData(point_right,i) < ImageData(point_right_new,i)
               point_right = point_right_new;
    %           point_left = point_left + step;
            else
               index2=1;
               point_right = point_right_new;
            end
        end

        [MaxAmp, index_max] = max(ImageData(point_left:point_right,i));
        ArrPt(i) = index_max + point_left - 1;
        InitialY = ArrPt(i);

    end  %end for

    % Center_T search down

    InitialY = ArrPt(InitialX);
    for i = (InitialX - 1):(-1):1
        index1 = 0;
        index2 = 0; 
        point_left = InitialY;
        point_right = InitialY;

        while index1 == 0
            point_left_new = max(1, point_left - step);
            if ImageData(point_left,i) < ImageData(point_left_new,i)
              point_left = point_left_new;
    %          point_right = point_right - step;
            else
               index1 = 1;
               point_left = point_left_new;
            end
        end
        while index2 == 0
            point_right_new = min(point_right + step, YSize);
            if ImageData(point_right,i) < ImageData(point_right_new,i)
               point_right = point_right_new;
    %           point_left = point_left + step;
            else
               index2=1;
               point_right = point_right_new;
            end
        end
    
    [MaxAmp, index_max] = max(ImageData(point_left:point_right,i));
    ArrPt(i) = index_max + point_left - 1;
    InitialY = ArrPt(i);
    end  %end for
    DispPt=ArrPt;
    cross_DeltaT=DeltaT;
    cross_StartT=StartT;
    df_freq = df_freq;
    cross_EndT=EndT;
    gfcn_WinMinV=WinMinV;
    gfcn_WinMaxV=WinMaxV;
    gfcn_DeltaV=DeltaV;
    gfcn_SampleF=SampleF;
    
    %GroupTime=reshape(GroupTime,1,length(GroupTime))

    fftNumPt = 2^nextpow2(gfcn_SampleF/df_freq);

    TPoint = cross_StartT:cross_DeltaT:cross_EndT;
    VPoint = gfcn_WinMinV:gfcn_DeltaV:gfcn_WinMaxV;
    VImgPt = length(VPoint); 
    WaveNumPt = length(WinWave);
    gfcn_GroupVDisp = zeros(1, cross_NumCtrT);  
    gfcn_GroupVDisp(1:cross_NumCtrT) = gfcn_WinMinV + (DispPt - 1)*gfcn_DeltaV;
    wavelength = TPoint.*gfcn_GroupVDisp(1:cross_NumCtrT);
    GroupTime = gfcn_StaDist./gfcn_GroupVDisp(1:cross_NumCtrT);
    g_WindnumT = g_WindnumT;
    g_Winmintime = g_Winmintime;
    GroupVwinMin = gfcn_StaDist./(GroupTime + max(g_WindnumT/2*TPoint,g_Winmintime));
    GroupVwinMax = gfcn_StaDist./(GroupTime - max(g_WindnumT/2*TPoint,g_Winmintime));
    III = find(GroupVwinMax <= 0);
    GroupVwinMax(III) = gfcn_WinMaxV*2;

    pWinMinV = max(1.02*gfcn_WinMinV*ones(1, cross_NumCtrT), GroupVwinMin);
    pWinMaxV = min(0.98*gfcn_WinMaxV*ones(1, cross_NumCtrT), GroupVwinMax);
    GroupVwinMin = pWinMinV;
    GroupVwinMax = pWinMaxV;
    filter_SampleF = gfcn_SampleF;
    %filter_SampleF =10;
    filter_SampleT = 1/filter_SampleF;
    filter_Length = 2^nextpow2(2^10*filter_SampleF);
    filter_CtrT =4
    filter_BandWidth = 0.025


    filter_LowF = (2/filter_SampleF)/(filter_CtrT + 0.5*filter_BandWidth);
    filter_KaiserPara=8
    filter_HighF = (2/filter_SampleF)/(filter_CtrT - 0.5*filter_BandWidth);  
    HalfFilterNum =  round(filter_Length/2);
    WinWave((WaveNumPt + 1):(WaveNumPt + HalfFilterNum)) = 0;
    % band pass filtering
    disp(df_freq);

    for numt = 1:cross_NumCtrT
        filter_CtrT = cross_StartT + (numt - 1)*cross_DeltaT;
        filter_CtrF = (2/filter_SampleF)/filter_CtrT;
        filter_LowF = (2/filter_SampleF)/(filter_CtrT + 0.5*filter_BandWidth);
        filter_HighF = (2/filter_SampleF)/(filter_CtrT - 0.5*filter_BandWidth);

        filter_Data = fir1(filter_Length, [filter_LowF,filter_HighF], kaiser(filter_Length + 1,filter_KaiserPara));
        FilteredWave = zeros(1,WaveNumPt + HalfFilterNum);
        %disp(filter.KaiserPara);
        %two-pass filtering (time and time-reverse) in order to remove phase shift
        winpt = round(max(g_WindnumT*filter_CtrT,g_Winmintime)*filter_SampleF);
        if mod(winpt,2) == 1  % to ensure winpt is even number
            winpt = winpt + 1;
        end                
        wintukey = tukeywin(winpt, 0.2);
        grouppt = winpt + round(GroupTime(numt)*filter_SampleF + 1);
        disp(size(zeros(1,winpt)));
        disp(size(WinWave(1:WaveNumPt)));
        disp(size(zeros(1,winpt)));
        tmpWave = [zeros(1,winpt) WinWave(1:WaveNumPt) zeros(1,winpt)];
        tmpWave((grouppt-winpt/2):(grouppt+winpt/2-1)) = tmpWave((grouppt-winpt/2):(grouppt+winpt/2-1)).*wintukey';
        tmpWave(1:(grouppt-winpt/2)) = 0;
        tmpWave((grouppt+winpt/2-1):end) = 0;
        NewWinWave = zeros(1, WaveNumPt + HalfFilterNum);
        NewWinWave(1:WaveNumPt) = tmpWave((winpt+1):(winpt+WaveNumPt));
        FilteredWave = fftfilt(filter_Data, NewWinWave(1:(WaveNumPt + HalfFilterNum)));
    %            figure; plot(WinWave(1:WaveNumPt),'r'); hold on; plot(NewWinWave); 
        FilteredWave = FilteredWave((WaveNumPt + HalfFilterNum):-1:1);
        FilteredWave = fftfilt(filter_Data, FilteredWave(1:(WaveNumPt + HalfFilterNum)));
        FilteredWave = FilteredWave((WaveNumPt + HalfFilterNum):-1:1);
        gfcn_PhaseImg(1:WaveNumPt,numt) = FilteredWave(1:WaveNumPt);
        gfcn_PhaseImg(1:WaveNumPt,numt) = gfcn_PhaseImg(1:WaveNumPt,numt)/max(abs(gfcn_PhaseImg(1:WaveNumPt,numt)));
    end
    timeptnum = g_WinMinPtNum:1:g_WinMaxPtNum;
    time = ((g_WinMinPtNum-1):1:(g_WinMaxPtNum-1))/gfcn_SampleF;
    gfcn_PhaseVImg = zeros(VImgPt, cross_NumCtrT);
    
    
    for i = 1:cross_NumCtrT
        CenterT = cross_StartT + (i - 1)*cross_DeltaT;
        TravPtV = gfcn_StaDist./(time - CenterT/8);
        if any(isinf(TravPtV))
            gfcn_PhaseVImg = zeros(VImgPt, cross_NumCtrT);
            break;
        end
        gfcn_PhaseVImg(1:VImgPt, i) = interp1(TravPtV, gfcn_PhaseImg(timeptnum,i), VPoint, 'spline');
    %          figure; plot(TravPtV, gfcn.PhaseImg(timeptnum,i)); hold on; plot(VPoint, gfcn.PhaseVImg(1:VImgPt, i), 'r--');
        gfcn_PhaseVImg(1:VImgPt, i) = gfcn_PhaseVImg(1:VImgPt, i)/max(abs(gfcn_PhaseVImg(1:VImgPt, i)));
    end
end