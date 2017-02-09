    function val=offstep(offset)
        global N
        global streubildMulti
        [~,~,eMulti]=rprofil((gpuArray(streubildMulti)),N/4,2,offset);
        val=gather(sum(eMulti));
    end