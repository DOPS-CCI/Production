'/* circular queue program using pointer*/
'/* every case is tested and shown in program*/
TYPE node
 dData AS DOUBLE
END TYPE

TYPE doubleQueue
 link AS node PTR
END TYPE

%NULL = 0

CLASS MyCircularQueuePTR

    INSTANCE front, rear AS LONG
    INSTANCE arr() AS DOUBLE
    INSTANCE rmsValue AS DOUBLE

    CLASS METHOD CREATE()
        ' Do initialization
        front = %NULL
        rear = %NULL
        cnt = 0
    END METHOD
CLASS cirque
{
PRIVATE : Node *front,*rear;
    INT COUNT;
public:   cirque();
    void push(INT n);
    void pop();
    void DISPLAY();
    ~cirque();
};
cirque::cirque()
{
 front=rear=NULL;
 COUNT=0;
}
void cirque::push(INT n)
{
 node *temp;
 temp=NEW node;
 IF(temp==NULL)
 {
  cout<<"memory is less";
  RETURN;
 }
 temp->DATA=n;
 IF(front==NULL)
 {
  front=rear=temp;
 }
 ELSE
 {
 rear->link=temp;
 rear=rear->link;
 }
 rear->link=front;
 COUNT++;

}
void cirque::pop()
{
 IF(front==NULL)
 {
  cout<<"ciccular queue is empty";
  RETURN;
 }
 node *temp;
 temp=front;
 cout<<endl<<"deleted item is"<<front->DATA;
 IF(COUNT>0)
 front=temp->link;
 rear->link=front;
 COUNT--;
 DELETE temp;
}
void cirque::DISPLAY()
{
 IF(front==NULL)
 {
  cout<<endl<<"queue is empty";
  RETURN;
 }
 INT LOCAL = COUNT;
 node *temp;
 temp=front;
 cout<<endl<<"queue elements are ";
 WHILE(LOCAL)
 {
  cout<<" "<<temp->DATA;
  temp=temp->link;
  LOCAL--;
 }
}
cirque::~cirque()
{
 IF(front==NULL)
 {
  cout<<endl<<"no memory used";
  RETURN;
 }
 node *temp;
 INT n=0;
 WHILE(front->link!=rear->link)
 {
  temp=front;
  front=front->link;
  DELETE temp;
  cout<<endl<<++n<<" "<<"deleted ";
 }
}
INT MAIN()
{
 cirque q;
 q.push(1);
 q.display();
 q.push(2);
 q.display();
 q.push(3);
 q.display();
 q.push(4);
 q.display();
 q.pop();
 q.pop();
 RETURN 0;
}

FUNCTION PBMAIN () AS LONG



END FUNCTION
