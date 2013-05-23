using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI;

/// <summary>
/// Summary description for TwoLineRadioButtonList
/// </summary>
/// 
namespace EprtrServerControls
{
    public class TwoLineRadioButtonList : RadioButtonList
    {


        public TwoLineRadioButtonList()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        protected override void RenderItem(ListItemType itemType, int repeatIndex, RepeatInfo repeatInfo, System.Web.UI.HtmlTextWriter writer)
        {
            // extract 
            string fulltext = Items[repeatIndex].Text;
            var split = fulltext.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);

            Items[repeatIndex].Text = split[0];


            writer.WriteBeginTag("div");
            //Add a style
            writer.Write(" style");
            writer.Write(HtmlTextWriter.EqualsDoubleQuoteString);
            writer.WriteStyleAttribute("float", "left");
            writer.Write(HtmlTextWriter.DoubleQuoteChar);
            //Output the '>' for the 'div' tag
            writer.Write(HtmlTextWriter.TagRightChar);

            // renders radio button first line of text
            base.RenderItem(itemType, repeatIndex, repeatInfo, writer);

            //Write end tag
            writer.WriteEndTag("div");

            if (split.Length > 1)
            {
                string text2 = split[1];

                writer.WriteBeginTag("br");
                writer.WriteEndTag("br");

                //Write begin tag without closing >
                writer.WriteBeginTag("label");
                //Add a style
                writer.Write(" style");
                writer.Write(HtmlTextWriter.EqualsDoubleQuoteString);
                writer.WriteStyleAttribute("padding-left", "18px");
                writer.WriteStyleAttribute("clear", "left");
                writer.Write(HtmlTextWriter.DoubleQuoteChar);
                //Output the '>' for the 'label' tag
                writer.Write(HtmlTextWriter.TagRightChar);
                
                // renders second line of text
                writer.Write(text2);
                                
                //Write end tag
                writer.WriteEndTag("label");
            }
        }

        protected override void Render(System.Web.UI.HtmlTextWriter writer)
        {
            base.Render(writer);
        }
    }
}
