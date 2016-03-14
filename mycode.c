int main(void) {
	printf("%s\n","Rounding Bug Example");
	printf("double:   %1.f\n",(125.85/41.95));
	printf("int cast: %d\n",(int)((125.85/41.95)));
	printf("round() : %d\n",(int)round((125.85/41.95)));
}
