import 'package:flutter/material.dart';
import 'package:metaapp/widget/addUser.dart';
import 'package:metaapp/widget/billEntry.dart';
import 'package:metaapp/widget/dashBoardBody.dart';
import 'package:metaapp/widget/loginHistory.dart';
import 'package:metaapp/widget/salesReport.dart';
import 'package:metaapp/widget/stockEntry.dart';
import 'package:metaapp/widget/stockView.dart';

List<Widget> getDashBoard(String userId,String role, int selectedOption) {
  switch (role) {
    case 'biller':
      if (selectedOption == 0) {
        // DashBoard
        return [
          DashBoardBody(loggedInUserRole: role, userId: userId)
          ];
      } else if (selectedOption == 1) {
        // Stock View
        return [
          StockViewPage(),
        ];
      } else if (selectedOption == 2) {
        // Bill Entry
        return [
          BillEntryPage( userId: userId)
        ];
      }
      break;

    case 'manager':
      if (selectedOption == 0) {
        // DashBoard
        return [ DashBoardBody(loggedInUserRole: role, userId: userId)];
      } else if (selectedOption == 1) {
        // Stock View
        return [
          StockViewPage(),
        ];
      } else if (selectedOption == 2) {
        // Stock Entry
        return [
             StockEntry(),
        ];
      } else if (selectedOption == 3) {
        // Sales Report
        return [
          SalesReport(),
        ];
      }
      break;

    case 'inventry':
      if (selectedOption == 0) {
        // DashBoard
        return [ DashBoardBody(loggedInUserRole: role, userId: userId)];
      } else if (selectedOption == 1) {
        // Stock View
        return [
          StockViewPage(),
        ];
      } else if (selectedOption == 2) {
        // Stock Entry
        return [
          StockEntry(),
        ];
      }
      break;

    case 'systemAdmin':
      if (selectedOption == 0) {
        // DashBoard
        return [ DashBoardBody(loggedInUserRole: role, userId: userId)];
      } else if (selectedOption == 1) {
        // Login History
        return [
          LoginHistory(),
        ];
      } else if (selectedOption == 2) {
        // Add User
        return [
          AddUser(),
        ];
      }
      break;

    default:
      break;
  }

  return [];
}
