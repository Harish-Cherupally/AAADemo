public WITH sharing class Exampl1 {
public List<Account> getAccts() {
return[SELECT id, Name FROM Account LIMIT 5000];
}
}