function [ output ] = complexwrap( input )
% id = (imag(input) < -pi) | (pi < imag(input));
% output=input;
% output(id)=real(output(id)) + 1i* (mod(pi+imag(output(id)),2*pi)-pi);
output=real(input) + 1i* (mod(imag(input),2*pi));
% output=real(input);
% tmp=imag(input);
% tmp=mod(tmp,2*pi);
% output=output+1i*tmp;
end

