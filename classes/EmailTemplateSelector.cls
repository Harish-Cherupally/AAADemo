public class EmailTemplateSelector {
    
    public static EmailTemplate getEmailTemplate(string name)
    {  
        return [Select Id,Name,Subject,HtmlValue,Body from EmailTemplate where name=:name LIMIT 1];
    }
}