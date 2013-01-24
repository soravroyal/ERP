////////////////////////////////////////////////////////////////////////////////
//
// Copyright © 2008 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/FlexViewer/License.txt
//
////////////////////////////////////////////////////////////////////////////////

package com.esri.solutions.flexviewer.utils
{
	import com.esri.solutions.flexviewer.BaseWidget;
	import mx.effects.Blur;
	import mx.effects.Move;
	import mx.effects.Parallel;
	import mx.effects.Resize;
	import mx.effects.Sequence;
	import mx.effects.SetPropertyAction;
	import mx.events.EffectEvent;
	
	/**
	 * WidgetEffects is a utility class with effects used when a widget panel is switched by the user.
	 */	
	public class WidgetEffects
	{
		
		/**
		 * Creates a new Widget Effects class.
		 */	
		public function WidgetEffects()
		{
		}
			    
	    public static function flipWidget(widget:BaseWidget, target:*, property:String, value:*, duration:Number):void
	    {
	    	var wTemplate:Object;
	    	var time:Number = 200;
	    	var h:Number = widget.height;
			var startY:Number;
			var midY:Number;
	    	
	    	wTemplate = widget.getChildAt(0);
	    	if (duration)
	    		time = duration / 2;
	    	startY = wTemplate.y;
	    	
	    	midY = startY + wTemplate.height / 2;
	    	if (target[property] != value)
	    	{	    		
	    		var seqEffect:Sequence = new Sequence();
	    		var spAction1:SetPropertyAction = new SetPropertyAction(widget);
				var spAction2:SetPropertyAction = new SetPropertyAction(target);
				var spAction3:SetPropertyAction = new SetPropertyAction(widget);
	    		var pEffect1:Parallel = new Parallel();
	    		var pEffect2:Parallel = new Parallel();
				var resizeEffect1:Resize = new Resize(wTemplate);
				var resizeEffect2:Resize = new Resize(wTemplate);
				var moveEffect1:Move = new Move(wTemplate);
				var moveEffect2:Move = new Move(wTemplate);
				var blurEffect1:Blur = new Blur(wTemplate);
				var blurEffect2:Blur = new Blur(wTemplate);
				
	    		spAction1.name = "height";
	    		spAction1.value = h;
				
				pEffect1.duration = time;
				
				resizeEffect1.duration = time;
				resizeEffect1.heightTo = 0;
				
				moveEffect1.duration = time;
				moveEffect1.yTo = midY;
				
				blurEffect1.duration = time;
				blurEffect1.blurYFrom = 0;
				blurEffect1.blurYTo = 20;
				
				pEffect1.addChild(resizeEffect1);
				pEffect1.addChild(moveEffect1);
				pEffect1.addChild(blurEffect1);
				
				spAction2.name = property;
	    		spAction2.value = value;
	    	
				pEffect2.duration = time;
				
				resizeEffect2.duration = time;
				resizeEffect2.heightTo = wTemplate.height;
					
				moveEffect2.duration = time;
				moveEffect2.yTo = startY;
					
				blurEffect2.duration = time;
				blurEffect2.blurYFrom = 10;
				blurEffect2.blurYTo = 0;
				
				spAction3.name = "explicitHeight";
				spAction3.value = NaN;
	    			
				pEffect2.addChild(resizeEffect2);
				pEffect2.addChild(moveEffect2);
				pEffect2.addChild(blurEffect2);
				
				seqEffect.addChild(spAction1);
	    		seqEffect.addChild(pEffect1);
	    		seqEffect.addChild(spAction2);
	    		seqEffect.addChild(pEffect2);
	    		seqEffect.addChild(spAction3);
	    		seqEffect.play();
	    	}
	    }
	     
	}
}