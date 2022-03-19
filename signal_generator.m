%function codes:
%dc = 0
%ramp = 1
%general order polynomial = 2
%exponential = 3
%sinusoidal = 4
%change codes:
%time reversal = 1
%time shift = 2
%compressing = 3
%expanding = 4
%amplitude scaling = 5
%no change = 6

function [] = signal_generator()
newline = sprintf('\n');
    function [FinalT, FinalF] = drawing(fs, breaknum, axis, functions, DCamplitudes, RAMPslopes, RAMPintercepts, POLYNamplitudes, POLYNpowers, POLYNintercepts, EXPamplitudes, EXPexponents, SINamplitudes, SINfrequencies, SINphases)
        DC = 1;
        RAMP = 1;
        POLYN = 1;
        EXP = 1;
        SIN = 1;

        start_time = axis(1);
        end_time = axis(end);

        FinalT = linspace(start_time, end_time, (end_time - start_time)*fs);
        FinalF = [];

        for i = 1:(breaknum+1)
            total_time = axis(i+1) - axis(i);
            t = linspace(axis(i), axis(i+1), fs*total_time);
            %actually calculating functions one by one
            switch functions(i)
                case 0
                    F = DCamplitudes(DC)*ones(1, fs*total_time);
                    DC = DC + 1;
                case 1
                    F = RAMPslopes(RAMP)*t + RAMPintercepts(RAMP);
                    RAMP = RAMP + 1;
                case 2
                    maxPower = POLYNpowers(POLYN);
                    F = POLYNintercepts(POLYN);
                    for j = 1:maxPower
                        F = F + POLYNamplitudes(j,POLYN) * t.^j;
                    end
                    POLYN = POLYN + 1;
                case 3
                    F = EXPamplitudes(EXP) * exp(t * EXPexponents(EXP));
                    EXP = EXP + 1;
                case 4
                    F = SINamplitudes(SIN)*sin(2*pi*SINfrequencies(SIN)*t + SINphases(SIN));
                    SIN = SIN + 1;
                otherwise
                    disp('CODE IS RUINED. RESTART FUNCTION. SORRY ENG. SALMA FOR INCONVENIENCE.')
            end
            if functions(i)==0 || functions(i)==1 || functions(i)==2 || functions(i)==3 || functions(i)==4
                FinalF = [FinalF F];
            end
        end
    end

    function [FinalT, FinalF] = transform(FinalT, FinalF, type_of_change, change)
        subplot(1, 2, 1)
        plot(FinalT, FinalF);
        title('Original Figure');
        switch type_of_change
            case 0
            case 1
                FinalT = FinalT * (-1);
            case 2
                FinalT = FinalT - change;
            case 3
                FinalT = change * FinalT;
            case 4
                FinalT = 1/change * FinalT;
            case 5
                FinalF = change * FinalF;
            case 6
            otherwise
                disp('CODE IS RUINED. RESTART FUNCTION. SORRY ENG. SALMA FOR INCONVENIENCE.')
        end
        subplot(1, 2, 2)
        plot(FinalT, FinalF);
        title('Modified Figure');
    end

fs = str2double(input('ENTER SAMPLING FREQUENCY: ', 's'));
while fs<=0 || isnan(fs)
    disp('Frequency can not be negative or zero, PLEASE RE-ENTER')
    fs = str2double(input('ENTER SAMPLING FREQUENCY: ', 's'));
end
start_time = str2double(input('ENTER START TIME: ', 's'));
while isnan(start_time)
    disp('INVALID START TIME, PLEASE RE-ENTER')
    start_time = str2double(input('ENTER START TIME: ', 's'));
end
end_time = str2double(input('ENTER END TIME: ', 's'));
while isnan(end_time)
    disp('INVALID END TIME,PLEASE RE-ENTER')
    end_time = str2double(input('ENTER END TIME: ', 's'));
end
while end_time <= start_time
    disp('INVALID, END TIME MUST BE GREATER THAN START TIME, PLEASE RE-ENTER');
    end_time = str2double(input('ENTER END TIME: ', 's'));
end
breaknum = str2double(input('ENTER NUMBER OF BREAKPOINTS: ', 's'));
while breaknum<0 || isnan(breaknum)
    disp('INVALID NUMBER OF BREAKPOINTS, PLEASE RE-ENTER');
    breaknum = str2double(input('ENTER NUMBER OF BREAKPOINTS: ', 's'));
end
breakpoints = zeros(1, breaknum);
functions = zeros(1, breaknum+1);

for i = 1:breaknum
    temp = str2double(input(['ENTER POSITION OF BREAKPOINT ' num2str(i) ': '], 's'));
    while temp >= end_time || temp <= start_time || isnan(temp)
        temp = str2double(input(['INVALID. REENTER POSITION OF BREAKPOINT ' num2str(i) ': '], 's'));
    end
    if i>1
        while temp <= breakpoints(i-1)
            disp('INVALID, PLEASE RE-ENTER');
            temp = str2double(input(['ENTER POSITION OF BREAKPOINT ' num2str(i) ': '], 's'));
        end
    end
    breakpoints(i) = temp;
end
str = ['AVAILABLE FUNCTIONS:' newline 'DC = 0' newline 'Ramp = 1' newline 'General order polynomial = 2' newline 'Exponential = 3' newline 'Sinusoidal = 4'];
disp(str);
for i = 1:(breaknum+1)
    if i == 1
        temp = str2double(input(['ENTER FUNCTION AT T = ' num2str(start_time) ': '], 's'));
        while temp~=0 && temp~=1 && temp~=2 && temp~=3 && temp~=4
            disp('PLEASE ENTER AVAILABLE FUNCTION');
            temp = str2double(input(['ENTER FUNCTION AT T = ' num2str(start_time) ': '], 's'));
        end
    else
        temp = str2double(input(['ENTER FUNCTION AT T = ' num2str(breakpoints(i-1)) ': '], 's'));
        while temp~=0 && temp~=1 && temp~=2 && temp~=3 && temp~=4
            disp('INVALID, PLEASE ENTER AVAILABLE FUNCTION!');
            temp = str2double(input(['ENTER FUNCTION AT T = ' num2str(breakpoints(i-1)) ': '], 's'));
        end
    end
    functions(i) = temp;
end
%initializing vectors of signal specifications
numberDC = sum(functions(:) == 0);
numberRAMP = sum(functions(:) == 1);
numberPOLYN = sum(functions(:) == 2);
numberEXP = sum(functions(:) == 3);
numberSIN = sum(functions(:) == 4);
DCamplitudes = zeros(1, numberDC);
RAMPslopes = zeros(1, numberRAMP);
RAMPintercepts = zeros(1, numberRAMP);
POLYNamplitudes = zeros(100, numberPOLYN);
POLYNpowers = zeros(1, numberPOLYN);
POLYNintercepts = zeros(1, numberPOLYN);
EXPamplitudes = zeros(1, numberEXP);
EXPexponents = zeros(1, numberEXP);
SINamplitudes = zeros(1, numberSIN);
SINfrequencies = zeros(1, numberSIN);
SINphases = zeros(1, numberSIN);

DC = 1;
RAMP = 1;
POLYN = 1;
EXP = 1;
SIN = 1;

for i = 1:(breaknum+1)
    switch functions(i)
        case 0
            disp(['DC SIGNAL: ' num2str(i)'])
            DCamplitudes(DC) = str2double(input('ENTER AMPLITUDE OF DC SIGNAL:', 's'));
            while isnan(DCamplitudes(DC))
                disp('INVALID, PLEASE RE-ENTER');
                DCamplitudes(DC) = str2double(input('ENTER AMPLITUDE OF DC SIGNAL:', 's'));
            end
            DC = DC + 1;
        case 1
            disp(['RAMP SIGNAL: ' num2str(i)'])
            RAMPslopes(RAMP) = str2double(input('ENTER SLOPE OF RAMP SIGNAL:', 's'));
            while isnan(RAMPslopes(RAMP))
                disp('INVALID, PLEASE RE-ENTER');
                RAMPslopes(RAMP) = str2double(input('ENTER SLOPE OF RAMP SIGNAL:', 's'));
            end
            RAMPintercepts(RAMP) = str2double(input('ENTER INTERCEPT OF RAMP SIGNAL:', 's'));
            while isnan(RAMPintercepts(RAMP))
                disp('INVALID, PLEASE RE-ENTER');
                RAMPintercepts(RAMP) = str2double(input('ENTER INTERCEPT OF RAMP SIGNAL:', 's'));
            end
            RAMP = RAMP + 1;
        case 2
            disp(['GENERAL ORDER POLYNOMIAL SIGNAL: ' num2str(i)'])
            POLYNpowers(POLYN) = str2double(input('ENTER POWER OF POLYNOMIAL SIGNAL:', 's'));
            while isnan(POLYNpowers(POLYN))
                disp('INVALID, PLEASE RE-ENTER');
                POLYNpowers(POLYN) = str2double(input('ENTER POWER OF POLYNOMIAL SIGNAL:', 's'));
            end
            POLYNintercepts(POLYN) = str2double(input('ENTER INTERCEPT OF POLYNOMIAL SIGNAL:', 's'));
            while isnan(POLYNintercepts(POLYN))
                disp('INVALID, PLEASE RE-ENTER');
                POLYNintercepts(POLYN) = str2double(input('ENTER INTERCEPT OF POLYNOMIAL SIGNAL:', 's'));
            end
            for j = 1:POLYNpowers(POLYN)
                POLYNamplitudes(j, POLYN) = str2double(input(['ENTER COEFFICIENT OF VARIABLE POWER ' num2str(j) ' :'], 's'));
                while isnan(POLYNamplitudes(j, POLYN))
                    disp('INVALID, PLEASE RE-ENTER');
                    POLYNamplitudes(j, POLYN) = str2double(input(['ENTER COEFFICIENT OF VARIABLE POWER ' num2str(j) ' :'], 's'));
                end
            end
            POLYN = POLYN + 1;
        case 3
            disp(['EXPONENTIAL SIGNAL: ' num2str(i)'])
            EXPamplitudes(EXP) = str2double(input('ENTER AMPLITUDE OF EXPONENTIAL SIGNAL:', 's'));
            while isnan(EXPamplitudes(EXP))
                disp('INVALID, PLEASE RE-ENTER');
                EXPamplitudes(EXP) = str2double(input('ENTER AMPLITUDE OF EXPONENTIAL SIGNAL:', 's'));
            end
            EXPexponents(EXP) = str2double(input('ENTER EXPONENT OF  EXPONENTIAL SIGNAL:', 's'));
            while isnan(EXPexponents(EXP))
                disp('INVALID, PLEASE RE-ENTER');
                EXPexponents(EXP) = str2double(input('ENTER EXPONENT OF  EXPONENTIAL SIGNAL:', 's'));
            end
            EXP = EXP + 1;
        case 4
            disp(['SINUSOIDAL SIGNAL: ' num2str(i)'])
            SINamplitudes(SIN) = str2double(input('ENTER AMPLITUDE OF SIN SIGNAL:', 's'));
            while isnan(SINamplitudes(SIN))
                disp('INVALID, PLEASSE RE-ENTER');
                SINamplitudes(SIN) = str2double(input('ENTER AMPLITUDE OF SIN SIGNAL:', 's'));
            end
            SINfrequencies(SIN) = str2double(input('ENTER FREQUENCY OF  SIN SIGNAL:', 's'));

            while SINfrequencies(SIN) <=0 || isnan(SINfrequencies(SIN))
                disp('Value of frequency must be positive integer');
                SINfrequencies(SIN) = str2double(input('ENTER FREQUENCY OF  SIN SIGNAL:', 's'));
            end
            SINphases(SIN) = str2double(input('ENTER PHASE OF  SIN SIGNAL:', 's'));
            while isnan(SINphases(SIN))
                disp('INVALID, PLEASE RE-ENTER');
                SINphases(SIN) = str2double(input('ENTER PHASE OF  SIN SIGNAL:', 's'));
            end
            SIN = SIN + 1;
        otherwise
            disp('CODE IS RUINED. RESTART FUNCTION. SORRY ENG. SALMA FOR INCONVENIENCE.')
    end
end

axis = [start_time breakpoints end_time];
[ogT, ogF] = drawing(fs, breaknum, axis, functions, DCamplitudes, RAMPslopes, RAMPintercepts, POLYNamplitudes, POLYNpowers, POLYNintercepts, EXPamplitudes, EXPexponents, SINamplitudes, SINfrequencies, SINphases);
[ogT, ogF] = transform(ogT, ogF, 0, 0);
ans = 0 ;
str = ['YOU CAN MODIFY YOUR SIGNAL AS PER THIS LIST:' newline 'Time reversal = 1' newline 'Time shift = 2' newline 'Expanding = 3' newline 'Compressing = 4' newline 'Amplitude Scaling = 5' newline 'None = 6'];
disp(str);
while ans == 0
    ans = str2double(input('DO YOU WANT TO MODIFY THE SIGNAL? ENTER 0 FOR YES, ANY NUMBER FOR NO: ', 's'));
    if ans == 0
        type_of_change = str2double(input('ENTER NUMBER OF TYPE OF MODIFICATION YOU WANT TO MAKE: ', 's'));
        while type_of_change~=6 && type_of_change~=1 && type_of_change~=2 && type_of_change~=3 && type_of_change~=4 && type_of_change~=5
            disp('PLEASE ENTER A VALID TYPE OF CHANGE');
            type_of_change = str2double(input('ENTER NUMBER OF TYPE OF MODIFICATION YOU WANT TO MAKE: ', 's'));
        end
        change = 0;
        if type_of_change == 2 || type_of_change == 3 || type_of_change == 4 || type_of_change == 5
            change = str2double(input('ENTER VALUE OF CHANGE: ', 's'));
            while isnan(change)
                disp('INVALID, PLEASE RE-ENTER');
                change = str2double(input('ENTER VALUE OF CHANGE: ', 's'));
            end

        end
        [ogT, ogF] = transform(ogT, ogF, type_of_change, change);
    else
        disp('THANK YOU FOR USING SIGNAL GENERATOR');
    end
end
end