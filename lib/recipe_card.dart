import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/classes/recipeInfo.dart';
import 'functions.dart';
import 'pages/recipe_page/recipe.dart';



//TODO: make different sizes for different images
// ignore: must_be_immutable
class RecipeCard extends StatelessWidget {
  RecipeInfo _recipeInfo;

  RecipeCard(RecipeInfo recipeInfo) {
	_recipeInfo = recipeInfo;
  }

  @override
  Widget build(BuildContext context) {
	
	return InkWell(
		onTap: () {
		  Navigator.push(
			context,
			CupertinoPageRoute(
			  builder: (context) => Recipe(_recipeInfo),
			),
		  );
		  addView(_recipeInfo.id);
		},
		child: Container(
			margin: EdgeInsets.all(10),
			width: MediaQuery.of(context).size.width * 0.97,
			height: _recipeInfo.ratio >= 1 ? MediaQuery.of(context).size.height * 0.4 : MediaQuery.of(context).size.height * 0.6,
			
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(10.0),
				image: DecorationImage(image: _recipeInfo.img, fit: BoxFit.cover),
				boxShadow: [
      				BoxShadow(
       				color: Colors.grey.withOpacity(0.5),
        			spreadRadius: 5,
        			blurRadius: 7,
        			offset: Offset(0, 2), // changes position of shadow
      				),
    			],

			),
			child: LayoutBuilder(
			  builder: (BuildContext context, BoxConstraints constraints) {
				return Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					  Column(
						children: [
						  Container(
							margin: EdgeInsets.all(10),
							width: constraints.maxWidth * 0.6,
							child: Text(
							  "${_recipeInfo.recipeName}",
							  maxLines: 2,
							  overflow: TextOverflow.ellipsis,
							  softWrap: false,
							  style: TextStyle(
								  fontSize: 25,
								  color: Colors.white,
								  fontWeight: FontWeight.bold),
							),
						  ),
						],
					  ),
					  Column(
						children: [
						  Container(
							margin: EdgeInsets.all(4),
							child: Text(
							  "${_recipeInfo.views} views",
							  maxLines: 1,
							  overflow: TextOverflow.ellipsis,
							  softWrap: false,
							  style: TextStyle(
								  fontSize: 20,
								  color: Colors.white,
								  fontWeight: FontWeight.bold),
							),
						  ),
						  Container(
							margin: EdgeInsets.all(4),
							child: Text(
							  "${_recipeInfo.rating}/5 rating",
							  maxLines: 1,
							  overflow: TextOverflow.ellipsis,
							  softWrap: false,
							  style: TextStyle(
								  fontSize: 20,
								  color: Colors.white,
								  fontWeight: FontWeight.bold),
							),
						  ),
						  Container(
							margin: EdgeInsets.all(4),
							child: Text(
							  "${_recipeInfo.difficulty}",
							  maxLines: 1,
							  overflow: TextOverflow.ellipsis,
							  softWrap: false,
							  style: TextStyle(
								  fontSize: 20,
								  color: Colors.white,
								  fontWeight: FontWeight.bold),
							),
						  )
						],
					  )
					]);
			  },
			)));
  }
}
