classdef list<handle

    %linked list of linked list node objects

    properties (Access=private)
        head=linkedlist.node.empty;
        tail=linkedlist.node.empty;
        count=0;
    end

    methods

        function this=list(varargin)
            this.count=0;
            for narg=1:nargin
                this.addElement(varargin{narg});
            end
        end

        function addElement(this,element)
            for n=1:length(element)
                this.removeElement(element(n));
                if ~isempty(this.head)
                    this.insertAfter(element(n),this.tail);
                else
                    this.head=element(n);
                    element(n).next=element(n);
                    element(n).prev=element(n);
                    this.tail=element(n);
                    element(n).list=this;
                    this.count=1;
                end
            end
        end

        function insertAfter(this,new,old)
            if isa(old,'linkedlist.node')&&   isa(new,'linkedlist.node')
                if (old==this.tail)
                    this.tail=new;
                end
                new.next=old.next;
                new.prev=old;
                old.next.prev=new;
                old.next=new;
                new.list=this;
                this.count=this.count+1;
            else
                error('Argument should be child of linkedlist.node')
            end
        end

        function removeElement(this,element)
            if isa(element,'linkedlist.node')
                if (this.head==element)
                    this.head=element.next;
                end
                if (this.tail==element)
                    this.tail=element.prev;
                end
                if ~isempty(element.next)
                    element.next.prev=element.prev;
                end
                if ~isempty(element.prev)
                    element.prev.next=element.next;

                end
                element.next=linkedlist.node.empty;

                element.prev=linkedlist.node.empty;
                if ~isempty(element.list)
                    element.list.count=element.list.count-1;
                    element.list=linkedlist.list.empty;
                end
            else
                error('Argument should be child of linkedlist.node')
            end
        end

        function elements=all(this)
            cur=this.head;
            elements(this.count)=linkedlist.node.empty;
            for n=this.count:-1:1
                elements(n)=cur;
                cur=cur.next;
            end
        end

        function clear(this)
            node=this.head;
            while ~isempty(node)
                nextnode=node.next;
                this.removeElement(node);
                node=nextnode;
            end
            this.head=linkedlist.node.empty;
            this.tail=linkedlist.node.empty;
        end

        function count=get.count(this)
            count=this.count;
        end

        function first=first(this)
            first=this.head;
        end

        function last=last(this)
            last=this.tail;
        end
    end
end
