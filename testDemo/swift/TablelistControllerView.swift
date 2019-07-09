//
//  TablelistControllerView.swift
//  testDemo
//
//  Created by lignpeng on 2019/7/9.
//  Copyright © 2019 genpeng. All rights reserved.
//

import UIKit

@objc class TablelistController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    lazy var imageArray = { () -> [String] in
        let array = Bundle.main.paths(forResourcesOfType: "png", inDirectory: "Resource/png")
        return array;
    }();
    
    lazy var vcArray = { () -> [String] in
        let array = ["IDViewController","GPExtensionViewController",
            "GPNullViewController","GPCellViewController",
            "LoadingViewController","GPTimeViewController",
            "GPSelectSeatViewController","ArrayEnumViewController",
            "SearchBarViewController","SinaWBSendingViewController",
            "DataBindingViewController","AlipayViewController",
            "AttributeLabelViewController","GPKeyBoardViewController",
            "GPVideoViewController","GPTableViewController",
            "GPGIFViewController","GPPopViewController",
            "ModelViewController","GGXibViewController",
            "CalulateImageViewController","GGPredicateViewController",
            "GGDateViewController","GGBlockViewController",
            "GGVIPDayViewController","GGSelectViewController",
            "GGMLeakViewController","GGSpaceViewController",
            "CSBrowsingHistoryListViewController","GGStringViewController",
            "GGRunTimeMethodViewController","TimezoneViewController",
            "GExcelViewController","RiseUpCalcViewController",
            "SelectManagerViewController","UISelectImageViewController",
            "UIClipImageViewController","EMailCheckViewController",
            "TimeCheckViewController","UIShapeImageClipViewController",
            "UIDataModelViewController","TableViewIndexViewController",
            "ButtonViewController"];
        return array;
    }();
    
    lazy var titleArray = { () -> [String] in
        let array = ["身份证验证","扩展view","nil、NULL的区别",
            "tableViewCell传：nil","图片旋转","倒计时60s",
            "选座排座","数组枚举",
            "搜索bar","微博分享","数据绑定：RZDataBinding",
            "支付宝网页拦截native支付","富文本","键盘弹起","摄像",
            "tableView操作","播放gif","弹出viewController",
            "对象转模型","xib使用","计算图片大小","谓词predicate",
            "时间校验","block多层回调","会员日弹框","弹出选择列表",
            "MLeakFinder使用","去空格","浏览历史","字符串包含",
            "runtime调用方法","获取当前时区","excel表","复利计算",
            "转盘","文字识别","图片裁剪","邮箱校验","年龄计算",
            "图案裁剪","数据解析","tableview索引","按钮图文"];
        return array;
    }();
    lazy var tableView = { () -> UITableView in
        let tableView = UITableView(frame:(CGRect)(x: 0,y: 0,width: 0,height: 0), style: .plain);
        tableView.rowHeight = 72;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(UINib.init(nibName: "GPTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cellIdentify");
        return tableView;
    }();
    
    override func viewDidLoad() {
        self.view.addSubview(self.tableView);
        self.tableView.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.top.equalTo()(self.view);
            make.left.equalTo()(self.view);
            make.right.equalTo()(self.view);
            make.bottom.equalTo()(self.view);
        };
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GPTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellIdentify") as! GPTableViewCell;
        cell.accessoryType = .disclosureIndicator;
        cell.iconImageView.image = UIImage(imageLiteralResourceName: self.imageArray[Int(arc4random()) % self.imageArray.count]);
        cell.backgroundColor = UIColor(red: CGFloat(arc4random() % 256) / 256.0, green: CGFloat(arc4random() % 256) / 256.0, blue: CGFloat(arc4random() % 256) / 256.0, alpha: 0.45);
        cell.titleLabel.text = self.titleArray[self.titleArray.count - 1 - indexPath.row];
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true);
        let vc = (NSClassFromString(self.vcArray[self.vcArray.count - 1 - indexPath.row]) as! UIViewController.Type).init()
        vc.title = self.titleArray[self.titleArray.count - 1 - indexPath.row];
        self.navigationController?.pushViewController(vc, animated: true);
    }
}
