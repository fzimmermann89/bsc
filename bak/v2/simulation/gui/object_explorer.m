classdef object_explorer<handle
    properties
        onchange=@()pause(0);
        settingSelected=@(x)display(x);
        objectSelected=@(x)display(x);
        enabled
        objects
        creatableObjects
        settings
        detailTable
    end
    properties (Dependent)
        position
    end
    properties (Access = private)
        mtree;
    end

    methods
        function this=object_explorer(parent,detailTable,objects,settings,creatableObjects)
            format=@(key,val)['<html><table style="width:100px"><tr><td>' key '</td><td align="right"><i>' val '</i></td></tr></table>'];

            % Objects
            %Todo anlegen von objekten aus data
            this.objects=objects;
            nodeObjects = uitreenode('v0', 'Objects', 'Objects', [], false);
            for n=1:length(objects)
                o=objects{n};
                packageAndName=strsplit(class(o),'.');
                value= format(sprintf('O%u',n),packageAndName{2});
                node=uitreenode('v0', num2str(n),value, [], false);
                nodeObjects.add(node);
            end

            % other Settings
            nodeSettings = uitreenode('v0', 'Settings', 'Settings', [], false);
            this.settings=settings;
            settingNames=fieldnames(settings);
            for n=1:length(settingNames)
                nodeSettings.add(uitreenode('v0',settingNames{n},settingNames{n},[],true));
            end

            % Root node
            root = uitreenode('v0', 'Simulation', 'Simulation', [], false);
            root.add(nodeSettings);
            root.add(nodeObjects);

            % Tree
            [this.mtree,container] = uitree('v0', 'Root', root, 'Parent',parent);
            %set(container, 'Parent', parent);
            container.Parent=parent;
            jtree=this.mtree.getTree;

            % Create Context Menu
            jmenu = javax.swing.JPopupMenu;

            % expand all nodes
            this.expandAll();

            jtree.setRootVisible(false)

            % Set the tree mouse-click callback
            set(jtree, 'MousePressedCallback', {@this.mousePressedCallback,jmenu});

            this.mtree.NodeSelectedCallback=@this.nodeSelectedCallback;

            % get parent position in pixels (is there a better way?)
            tmpunits=parent.Units;parent.Units='pixel';parentpos=parent.Position;parent.Units=tmpunits;

            this.position= [5,5,parentpos(3)-10,parentpos(4)-10];
            this.creatableObjects=creatableObjects;
            this.detailTable=detailTable;

        end

        function expandAll(this)
            %Traverses all nodes and expands them
            jtree=this.mtree.getTree;
            n=0;
            while n<jtree.getRowCount
                jtree.expandRow(n);
                n=n+1;
            end
        end

        function set.position(this,val)
            this.mtree.Position=val;
        end
        function pos=get.position(this)
            pos=this.mtree.Position;
        end
    end
    methods (Access = private)
        function nodeSelectedCallback(this,hTree,eventData)
            %Called whenver a Node is selected, shall update the Table
            nodes = hTree.getSelectedNodes;
            node = nodes(1);
            nodeName=char(node.getValue);
            parentName=char(node.getParent.getName);
            if strcmp(parentName,'Objects')
                selectedObject=this.objects{str2double(nodeName)};
                props=properties(selectedObject);
                data=cell(length(props),3);
                for n=1:length(props)

                    name=props{n};
                    value=selectedObject.(name);
                    %                     minmax= sprintf('[%f;%f]',curSetting.minValue,curSetting.maxValue);
                    data(n,:)={name,.value, 0};
                end
                this.detailTable.Data=data;
                %Update Table data for selected Object
                %                 this.objectSelected(node.getValue);


            elseif strcmp(parentName,'Settings')
                %Update Table data for selected Setting
                fields=fieldnames(this.settings.(nodeName));
                data=cell(length(fields),3);
                for n=1:length(fields)
                    name=fields{n};
                    curSetting=this.settings.(nodeName).(name);
                    minmax= sprintf('[%f;%f]',curSetting.minValue,curSetting.maxValue);
                    data(n,:)={name, curSetting.value, minmax};
                end
                this.detailTable.Data=data;
                %                  this.detailTable.CellEditCallback=@
                set(this.detailTable,'CellEditCallback',{@this.setSetting,nodeName});
            end%if
        end %nodeSelectedCallback
        function mousePressedCallback(this, hTree, eventData, jmenu)
            if eventData.isMetaDown  % right-click is like a Meta-button
                %clear old menu
                jmenu.removeAll;
                % Get the clicked node
                clickX = eventData.getX;
                clickY = eventData.getY;
                treePath = hTree.getPathForLocation(clickX, clickY);
                if ~isempty(treePath)
                    node = treePath.getLastPathComponent;
                    %actually clicked on node
                    if strcmp(node.getParent.getName,'Objects')
                        %clicked on an object
                        %construct context menu
                        itemDelete = javax.swing.JMenuItem('Delete');
                        itemDuplicate = javax.swing.JMenuItem('Duplicate');
                        set(itemDelete,'ActionPerformedCallback',{@this.delete,hTree,node});
                        set(itemDuplicate,'ActionPerformedCallback',{@this.duplicate,hTree,node});
                        jmenu.add(itemDelete);
                        jmenu.add(itemDuplicate);
                    elseif strcmp(node.getName,'Objects')
                        %clicked on objects
                        %construct context menu
                        for n=length(this.creatableObjects):-1:1;
                            items(n)=javax.swing.JMenuItem(this.creatableObjects(n));
                            set(items(n),'ActionPerformedCallback',{@(~,~,name)display(name),this.creatableObjects(n)});
                            jmenu.add(items(n));
                        end

                    elseif strcmp(node.getParent.getName,'Settings')
                        %clicked on settings


                        itemReset = javax.swing.JMenuItem('Reset');
                        %set(itemReset,'ActionPerformedCallback',{@this.delete,hTree,node});
                        jmenu.add(itemReset);
                    end

                end
                %show the menu
                jmenu.show(hTree, clickX, clickY);
            end

        end
        % Menu items callbacks
        function delete(this, hObject, eventData, hTree,node)
            hTree.enabled=false;
            model=hTree.getModel;
            javaMethodEDT('removeNodeFromParent',model,node);
            if isa(this.onchange,'function_handle'), this.onchange(),end
            hTree.enabled=true;
        end
        function duplicate(this, hObject, eventData, hTree,node)
            hTree.enabled=false;
            model=hTree.getModel;
            javaMethodEDT('insertNodeInto',model,node.clone,node.getParent,0);
            if isa(this.onchange,'function_handle'), this.onchange(),end
            hTree.enabled=true;
        end
        function add
        end
        function setSetting(this,hObject,eventData,nodeName)
            settingNames=fieldnames(this.settings.(nodeName));
            settingName=settingNames{eventData.Indices(1)} ;
            this.settings.(nodeName).(settingName).value=eventData.NewData;
        end
    end
    methods (Static)

        function text=keyval(key,val)
            text=['<html><table style="width:100px"><tr><td>' key '</td><td align="right"><i>' val '</i></td></tr></table>'];
        end
    end
end