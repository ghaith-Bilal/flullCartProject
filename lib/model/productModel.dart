class Product{
  String pName;
  String pDescription;
  int pPrice;
  String pImage;
  String pCategory;
  int pQuantity;

  Product(
      {this.pName,
        this.pDescription,
        this.pPrice,
        this.pImage,
        this.pCategory,
        this.pQuantity});
  static Product fromJson(Map <String,dynamic> jsonItem){
    return Product(pName: jsonItem['p_Name'],
        pDescription: jsonItem['p_Description'],
        pPrice: jsonItem['p_Price'],
        pImage: jsonItem['p_Image'],
        pCategory: jsonItem['p_Category'],
        pQuantity: jsonItem['p_Quantity']);
  }
  Map<String,dynamic> toJson(){
    return {
      'p_Name':pName,
      'p_Description':pDescription,
      'p_Price':pPrice,
      'p_Image':pImage,
      'p_Category':pCategory,
      'p_Quantity':pQuantity
    };
  }
}