/**
*  Description : Controller Class to show How to utilize existing List View in Apex with Pagination Support
*
*/
public with sharing class aaa {

    private String baseQuery = 'Select id, Name, FirstName, Title, Email, Phone, MobilePhone from Contact  where phone !=null';
    public String conFilterId { get; set; }
    private Integer pageSize = 20;
    private String sortDirection = 'ASC';
    private String sortExp = 'name';
    public List<Contact> contacts = Database.query(baseQuery);

    public ApexPages.StandardSetController con {
        get {
            if (con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
                con.setPageSize(pageSize);
                // We have to set FilterId after Pagesize, else it will not work
                if (conFilterId != null) {
                    con.setFilterId(conFilterId);
                }
            }
            return con;
        }
        set;
    }

    public void previous() {
        con.previous();
    }
    public void next() {
        con.next();
    }
    public void first() {
        con.first();
    }
    public void last() {
        con.last();
    }
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    public List<Contact> getContacts() {
        return (List<Contact>) con.getRecords();
    }
    //Get all available list view for Contact
    public SelectOption[] getExistingViews() {
        return con.getListViewOptions();
    }

    public PageReference resetFilter() {
        con = null;
        con.setPageNumber(1);
        return null;
    }
    public String sortExpression {
        get {
            return sortExp;
        }
        set {
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC') ? 'DESC' : 'ASC'; else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }
    public String getSortDirection() {
//if not column is selected
        if (sortExpression == null || sortExpression == '')
            return 'ASC'; else
            return sortDirection;
    }
    public void setSortDirection(String value) {
        sortDirection = value;
    }
    public PageReference ViewData() {
        string sortFullExp = sortExpression + ' ' + sortDirection;
        contacts = Database.query(baseQuery + ' order by ' + sortFullExp + ' limit 1000 ');
        con = new ApexPages.StandardSetController(contacts);
        con.setSelected(contacts);

        return null;
    }
}