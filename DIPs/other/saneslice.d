import basic;
struct foo{
	void opSlice(int i,int j){
		i.writeln;
		j.writeln;
	}
}
unittest{
	foo bar;
	bar[1..2];
}