import Product from '../models/product.js';
import { uploadToCloudinary } from '../utils/cloudinary.js';

export const productController = {
  // Create a new product
  createProduct: async (req, res) => {
    try {
      const { name, price, description, category, stock } = req.body;
      
      // Handle image upload
      let imageUrl;
      if (req.file) {
        const result = await uploadToCloudinary(req.file.path);
        imageUrl = result.secure_url;
      }

      const newProduct = new Product({
        name,
        price,
        description,
        category,
        image: imageUrl,
        stock
      });

      const savedProduct = await newProduct.save();
      res.status(201).json(savedProduct);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Get all products with filters and pagination
  getProducts: async (req, res) => {
    try {
      const { 
        page = 1, 
        limit = 10, 
        category, 
        search,
        minPrice,
        maxPrice,
        sort 
      } = req.query;

      // Build filter object
      const filter = {};
      
      if (category) filter.category = category;
      if (search) filter.$text = { $search: search };
      if (minPrice || maxPrice) {
        filter.price = {};
        if (minPrice) filter.price.$gte = Number(minPrice);
        if (maxPrice) filter.price.$lte = Number(maxPrice);
      }

      // Build sort object
      let sortOption = {};
      if (sort === 'price_asc') sortOption.price = 1;
      if (sort === 'price_desc') sortOption.price = -1;
      if (sort === 'newest') sortOption.created_at = -1;

      const products = await Product.find(filter)
        .populate('category', 'name')
        .sort(sortOption)
        .skip((page - 1) * limit)
        .limit(limit);

      const total = await Product.countDocuments(filter);

      res.json({
        products,
        currentPage: Number(page),
        totalPages: Math.ceil(total / limit),
        totalProducts: total
      });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Get a single product by ID
  getProductById: async (req, res) => {
    try {
      const product = await Product.findById(req.params.id)
        .populate('category', 'name');
      
      if (!product) {
        return res.status(404).json({ message: 'Product not found' });
      }
      
      res.json(product);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Update a product
  updateProduct: async (req, res) => {
    try {
      const { name, price, description, category, stock } = req.body;
      
      let updateData = {
        name,
        price,
        description,
        category,
        stock,
        updated_at: Date.now()
      };

      // Handle image upload if new image is provided
      if (req.file) {
        const result = await uploadToCloudinary(req.file.path);
        updateData.image = result.secure_url;
      }

      const updatedProduct = await Product.findByIdAndUpdate(
        req.params.id,
        updateData,
        { new: true }
      ).populate('category', 'name');

      if (!updatedProduct) {
        return res.status(404).json({ message: 'Product not found' });
      }

      res.json(updatedProduct);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Delete a product
  deleteProduct: async (req, res) => {
    try {
      const deletedProduct = await Product.findByIdAndDelete(req.params.id);
      
      if (!deletedProduct) {
        return res.status(404).json({ message: 'Product not found' });
      }

      res.json({ message: 'Product deleted successfully' });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Search products
  searchProducts: async (req, res) => {
    try {
      const { query } = req.query;
      const products = await Product.find(
        { $text: { $search: query } },
        { score: { $meta: "textScore" } }
      )
      .sort({ score: { $meta: "textScore" } })
      .populate('category', 'name');

      res.json(products);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
};